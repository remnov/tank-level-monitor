# Tank Level Monitor

A complete IoT solution for monitoring tank water levels using a Lolin D1 Mini (ESP8266) with ultrasonic sensor and an iOS app for real-time monitoring.

## Features

### ESP8266 (Lolin D1 Mini)
- **Ultrasonic Sensor Integration**: HC-SR04 or similar ultrasonic sensor for distance measurement
- **WiFi Connectivity**: Automatic WiFi configuration using WiFiManager
- **Web Server**: Built-in HTTP server with REST API endpoints
- **Real-time Monitoring**: Continuous water level measurements every 5 seconds
- **Data Smoothing**: Algorithm to reduce measurement noise
- **LED Indicators**: Built-in LED shows measurement activity

### iOS App
- **Real-time Display**: Live tank level visualization with animated water level
- **Connection Management**: Easy device IP configuration and connection testing
- **Visual Indicators**: Color-coded water levels (Empty, Low, Good, Full)
- **Settings Panel**: Configure device IP address and test connectivity
- **Modern UI**: SwiftUI-based interface with smooth animations

## Hardware Requirements

### ESP8266 Setup
- **Lolin D1 Mini** (or any ESP8266-based board)
- **HC-SR04 Ultrasonic Sensor** (or compatible)
- **Breadboard and Jumper Wires**
- **Power Supply** (USB or 3.3V)

### Wiring Diagram
```
Lolin D1 Mini    HC-SR04
VCC (3.3V)  -->  VCC
GND         -->  GND
D1 (GPIO5)  -->  TRIG
D2 (GPIO4)  -->  ECHO
```

## Software Setup

### ESP8266 Setup

1. **Install Arduino IDE or PlatformIO**
   - Download Arduino IDE from [arduino.cc](https://www.arduino.cc/en/software)
   - Or install PlatformIO for better dependency management

2. **Install Required Libraries**
   ```bash
   # If using PlatformIO (recommended)
   # The platformio.ini file already includes all dependencies
   
   # If using Arduino IDE, install these libraries:
   # - ESP8266WiFi
   # - ESP8266WebServer
   # - ArduinoJson (by Benoit Blanchon)
   # - WiFiManager (by tzapu)
   ```

3. **Configure Tank Parameters**
   Open `esp8266/tank_level_sensor.ino` and adjust:
   ```cpp
   const float TANK_HEIGHT_CM = 100.0;  // Your tank height in cm
   const float MIN_DISTANCE_CM = 5.0;   // Min distance from sensor to water
   const float MAX_DISTANCE_CM = 95.0;  // Max distance from sensor to water
   ```

4. **Upload Code**
   - Connect Lolin D1 Mini via USB
   - Select board: "Lolin (Wemos) D1 R2 & mini"
   - Upload the sketch

5. **WiFi Configuration**
   - On first boot, the device creates a WiFi hotspot named "TankLevelMonitor"
   - Connect to this hotspot and configure your WiFi credentials
   - The device will remember the settings for future boots

### iOS App Setup

1. **Prerequisites**
   - Xcode 15.0 or later
   - iOS 17.0 or later
   - Apple Developer Account (for device deployment)

2. **Open Project**
   ```bash
   cd ios-app
   open TankLevelMonitor.xcodeproj
   ```

3. **Build and Run**
   - Select your target device (iPhone/iPad or Simulator)
   - Press Cmd+R to build and run

4. **Configure Device IP**
   - Open the app
   - Go to Settings
   - Enter your ESP8266 device's IP address
   - Test the connection

## API Endpoints

The ESP8266 provides the following REST API endpoints:

### GET /api/level
Returns current tank level data:
```json
{
  "waterLevel": 75.5,
  "percentage": 75.5,
  "timestamp": 1234567890,
  "status": "success"
}
```

### GET /api/status
Returns device status:
```json
{
  "status": "online",
  "uptime": 1234567890,
  "wifiRSSI": -45,
  "freeHeap": 12345
}
```

### GET /
Returns a simple HTML dashboard for web browser access.

## Configuration

### Tank Calibration
1. Measure your tank's total height in centimeters
2. Update `TANK_HEIGHT_CM` in the Arduino code
3. Position the ultrasonic sensor at the top of the tank
4. Adjust `MIN_DISTANCE_CM` and `MAX_DISTANCE_CM` based on your setup

### WiFi Settings
- The device uses WiFiManager for easy configuration
- No need to hardcode WiFi credentials
- Settings are stored in ESP8266's flash memory

### iOS App Settings
- Device IP address is configurable in the app
- Settings are saved locally using UserDefaults
- Connection testing available in Settings panel

## Troubleshooting

### ESP8266 Issues
1. **Device not connecting to WiFi**
   - Check if the device is in configuration mode
   - Look for "TankLevelMonitor" WiFi network
   - Ensure correct WiFi credentials

2. **Incorrect measurements**
   - Check sensor wiring (TRIG and ECHO pins)
   - Verify tank height configuration
   - Ensure sensor is properly positioned

3. **Web server not accessible**
   - Check device IP address in Serial Monitor
   - Ensure device and phone are on same network
   - Test with web browser first

### iOS App Issues
1. **Cannot connect to device**
   - Verify device IP address in Settings
   - Ensure both devices are on same WiFi network
   - Test connection using the "Test Connection" button

2. **App crashes**
   - Check Xcode console for error messages
   - Ensure iOS version compatibility
   - Verify network permissions

## Development

### Project Structure
```
tank-level-monitor/
├── esp8266/
│   ├── tank_level_sensor.ino    # Main Arduino sketch
│   └── platformio.ini          # PlatformIO configuration
├── ios-app/
│   └── TankLevelMonitor/
│       ├── TankLevelMonitorApp.swift
│       ├── ContentView.swift
│       ├── TankLevelView.swift
│       ├── TankLevelService.swift
│       ├── SettingsView.swift
│       └── Assets.xcassets/
└── docs/
    └── README.md
```

### Adding Features
- **Data Logging**: Add SD card support to ESP8266
- **Cloud Integration**: Send data to cloud services
- **Alerts**: Add push notifications for low water levels
- **Multiple Tanks**: Support for multiple sensors
- **Historical Data**: Add charts and data visualization

## License

This project is open source and available under the MIT License.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review the code comments
3. Open an issue on GitHub
4. Check the ESP8266 and iOS documentation

## Version History

- **v1.0.0**: Initial release with basic tank level monitoring
  - ESP8266 with ultrasonic sensor
  - iOS app with real-time display
  - WiFi configuration
  - REST API endpoints 