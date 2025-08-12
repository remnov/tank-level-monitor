#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>
#include <WiFiManager.h>

// Pin definitions for Lolin D1 Mini
const int TRIG_PIN = D1;  // GPIO5
const int ECHO_PIN = D2;  // GPIO4
const int LED_PIN = D4;   // Built-in LED

// Tank configuration
const float TANK_HEIGHT_CM = 100.0;  // Adjust based on your tank height
const float MIN_DISTANCE_CM = 5.0;   // Minimum distance from sensor to water
const float MAX_DISTANCE_CM = 95.0;  // Maximum distance from sensor to water

// WiFi and server configuration
ESP8266WebServer server(80);
WiFiManager wifiManager;

// Global variables
float lastWaterLevel = 0.0;
unsigned long lastMeasurement = 0;
const unsigned long MEASUREMENT_INTERVAL = 5000; // 5 seconds

void setup() {
  Serial.begin(115200);
  Serial.println("Tank Level Monitor Starting...");
  
  // Initialize pins
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);
  
  // Initialize WiFi
  setupWiFi();
  
  // Setup web server routes
  setupWebServer();
  
  Serial.println("Setup complete!");
}

void loop() {
  // Handle WiFi manager
  wifiManager.process();
  
  // Handle web server
  server.handleClient();
  
  // Take measurements periodically
  if (millis() - lastMeasurement >= MEASUREMENT_INTERVAL) {
    measureWaterLevel();
    lastMeasurement = millis();
  }
  
  delay(100);
}

void setupWiFi() {
  // Set WiFi mode
  WiFi.mode(WIFI_STA);
  
  // Configure WiFi Manager
  wifiManager.setConfigPortalTimeout(180); // 3 minutes
  wifiManager.setAPCallback([](WiFiManager *myWiFiManager) {
    Serial.println("Entered config mode");
    Serial.println(WiFi.softAPIP());
    Serial.println(myWiFiManager->getConfigPortalSSID());
  });
  
  // Try to connect to WiFi
  if (!wifiManager.autoConnect("TankLevelMonitor")) {
    Serial.println("Failed to connect and hit timeout");
    ESP.restart();
  }
  
  Serial.println("WiFi connected!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  
  // Start web server
  server.begin();
  Serial.println("HTTP server started");
}

void setupWebServer() {
  // API endpoint to get tank level
  server.on("/api/level", HTTP_GET, []() {
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.sendHeader("Content-Type", "application/json");
    
    StaticJsonDocument<200> doc;
    doc["waterLevel"] = lastWaterLevel;
    doc["percentage"] = calculatePercentage(lastWaterLevel);
    doc["timestamp"] = millis();
    doc["status"] = "success";
    
    String response;
    serializeJson(doc, response);
    server.send(200, "application/json", response);
  });
  
  // API endpoint to get sensor status
  server.on("/api/status", HTTP_GET, []() {
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.sendHeader("Content-Type", "application/json");
    
    StaticJsonDocument<200> doc;
    doc["status"] = "online";
    doc["uptime"] = millis();
    doc["wifiRSSI"] = WiFi.RSSI();
    doc["freeHeap"] = ESP.getFreeHeap();
    
    String response;
    serializeJson(doc, response);
    server.send(200, "application/json", response);
  });
  
  // Root endpoint with simple HTML
  server.on("/", HTTP_GET, []() {
    String html = "<!DOCTYPE html><html><head><title>Tank Level Monitor</title>";
    html += "<meta name='viewport' content='width=device-width, initial-scale=1'>";
    html += "<style>";
    html += "body{font-family:Arial,sans-serif;margin:20px;text-align:center;}";
    html += ".level{font-size:48px;font-weight:bold;color:#007bff;}";
    html += ".percentage{font-size:24px;color:#666;}";
    html += ".status{font-size:16px;color:#28a745;}";
    html += "</style></head><body>";
    html += "<h1>Tank Level Monitor</h1>";
    html += "<div class='level' id='level'>--</div>";
    html += "<div class='percentage' id='percentage'>--%</div>";
    html += "<div class='status' id='status'>Connected</div>";
    html += "<script>";
    html += "function updateLevel(){";
    html += "fetch('/api/level').then(r=>r.json()).then(data=>{";
    html += "document.getElementById('level').textContent=data.waterLevel.toFixed(1)+' cm';";
    html += "document.getElementById('percentage').textContent=data.percentage.toFixed(1)+'%';";
    html += "});}";
    html += "setInterval(updateLevel,5000);updateLevel();";
    html += "</script></body></html>";
    server.send(200, "text/html", html);
  });
  
  // Handle 404
  server.onNotFound([]() {
    server.send(404, "text/plain", "Not found");
  });
}

float measureWaterLevel() {
  // Clear trigger pin
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  
  // Send trigger pulse
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  
  // Measure echo duration
  long duration = pulseIn(ECHO_PIN, HIGH, 30000); // 30ms timeout
  
  if (duration == 0) {
    Serial.println("Measurement timeout");
    return lastWaterLevel;
  }
  
  // Calculate distance in cm
  float distance = duration * 0.034 / 2;
  
  // Validate distance
  if (distance < MIN_DISTANCE_CM || distance > MAX_DISTANCE_CM) {
    Serial.print("Invalid distance: ");
    Serial.println(distance);
    return lastWaterLevel;
  }
  
  // Calculate water level (distance from sensor to water surface)
  float waterLevel = TANK_HEIGHT_CM - distance;
  
  // Apply simple smoothing
  if (lastWaterLevel == 0) {
    lastWaterLevel = waterLevel;
  } else {
    lastWaterLevel = lastWaterLevel * 0.7 + waterLevel * 0.3;
  }
  
  Serial.print("Distance: ");
  Serial.print(distance);
  Serial.print(" cm, Water Level: ");
  Serial.print(lastWaterLevel);
  Serial.print(" cm (");
  Serial.print(calculatePercentage(lastWaterLevel));
  Serial.println("%)");
  
  // Blink LED to indicate measurement
  digitalWrite(LED_PIN, HIGH);
  delay(50);
  digitalWrite(LED_PIN, LOW);
  
  return lastWaterLevel;
}

float calculatePercentage(float waterLevel) {
  if (waterLevel <= 0) return 0.0;
  if (waterLevel >= TANK_HEIGHT_CM) return 100.0;
  return (waterLevel / TANK_HEIGHT_CM) * 100.0;
} 