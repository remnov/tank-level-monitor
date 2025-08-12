# Quick Start Guide

Get your tank level monitor up and running in 10 minutes!

## Prerequisites

- Lolin D1 Mini (ESP8266)
- HC-SR04 Ultrasonic Sensor
- Jumper wires
- USB cable
- iPhone/iPad with iOS 17+
- Xcode 15+ (for iOS app)

## Step 1: Hardware Setup (2 minutes)

1. **Connect the sensor:**
   ```
   Lolin D1 Mini  →  HC-SR04
   3.3V          →  VCC
   GND           →  GND
   D1 (GPIO5)    →  TRIG
   D2 (GPIO4)    →  ECHO
   ```

2. **Mount sensor** at the top of your tank, pointing down

## Step 2: ESP8266 Setup (3 minutes)

1. **Open Arduino IDE**
2. **Install libraries:**
   - Go to Tools → Manage Libraries
   - Search and install:
     - "ArduinoJson" by Benoit Blanchon
     - "WiFiManager" by tzapu

3. **Upload code:**
   - Open `esp8266/tank_level_sensor.ino`
   - Select board: "Lolin (Wemos) D1 R2 & mini"
   - Click Upload

4. **Configure WiFi:**
   - Look for "TankLevelMonitor" WiFi network
   - Connect to it
   - Enter your WiFi credentials
   - Note the IP address shown in Serial Monitor

## Step 3: iOS App Setup (3 minutes)

1. **Open Xcode**
2. **Open project:**
   ```bash
   cd ios-app
   open TankLevelMonitor.xcodeproj
   ```

3. **Build and run:**
   - Select your iPhone/iPad
   - Press Cmd+R

4. **Configure device:**
   - Open app
   - Go to Settings
   - Enter the IP address from Step 2
   - Test connection

## Step 4: Test (2 minutes)

1. **Check ESP8266:**
   - Open Serial Monitor (115200 baud)
   - Verify sensor readings

2. **Check iOS app:**
   - Should show real-time tank level
   - Water level should animate when you move sensor

## Troubleshooting

### ESP8266 Issues
- **No WiFi**: Check if "TankLevelMonitor" network appears
- **No readings**: Check sensor wiring
- **Wrong readings**: Adjust `TANK_HEIGHT_CM` in code

### iOS App Issues
- **Can't connect**: Verify IP address and network
- **App crashes**: Check Xcode console for errors

## Next Steps

- Calibrate tank height in ESP8266 code
- Add waterproof enclosure
- Set up alerts for low water levels
- Add data logging

## Need Help?

- Check the full README.md
- Review wiring_diagram.md
- Check Serial Monitor for error messages
- Verify all connections are secure 