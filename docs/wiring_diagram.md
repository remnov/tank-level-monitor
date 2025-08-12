# Hardware Setup Guide

## Wiring Diagram

### Lolin D1 Mini Pinout
```
Lolin D1 Mini Pinout:
┌─────────────────┐
│                 │
│  D1 (GPIO5)     │  ← TRIG Pin (Ultrasonic Sensor)
│  D2 (GPIO4)     │  ← ECHO Pin (Ultrasonic Sensor)
│  D3 (GPIO0)     │
│  D4 (GPIO2)     │  ← Built-in LED
│  D5 (GPIO14)    │
│  D6 (GPIO12)    │
│  D7 (GPIO13)    │
│  D8 (GPIO15)    │
│                 │
│  3.3V           │  ← Power for Sensor
│  GND            │  ← Ground
│                 │
└─────────────────┘
```

### HC-SR04 Ultrasonic Sensor Pinout
```
HC-SR04 Pinout:
┌─────────────┐
│             │
│  VCC        │  ← 3.3V Power
│  TRIG       │  ← Trigger Signal
│  ECHO       │  ← Echo Signal
│  GND        │  ← Ground
│             │
└─────────────┘
```

### Complete Wiring
```
Lolin D1 Mini          HC-SR04
┌─────────────┐        ┌─────────────┐
│             │        │             │
│  3.3V ──────┼───────→│ VCC         │
│             │        │             │
│  D1 ────────┼───────→│ TRIG        │
│             │        │             │
│  D2 ←───────┼───────│ ECHO        │
│             │        │             │
│  GND ───────┼───────→│ GND         │
│             │        │             │
└─────────────┘        └─────────────┘
```

## Hardware Components

### Required Components
1. **Lolin D1 Mini** (ESP8266-based board)
   - Microcontroller: ESP8266
   - Operating Voltage: 3.3V
   - USB Type-C connector
   - Built-in WiFi

2. **HC-SR04 Ultrasonic Sensor**
   - Operating Voltage: 5V (but works with 3.3V)
   - Detection Range: 2cm - 400cm
   - Accuracy: ±3mm
   - Trigger Input: 10μs TTL pulse
   - Echo Output: TTL level signal

3. **Breadboard** (optional but recommended)
   - For easy prototyping and testing

4. **Jumper Wires**
   - Male-to-male jumper wires
   - Recommended: 4 wires (VCC, GND, TRIG, ECHO)

5. **Power Supply**
   - USB cable for programming and power
   - Or external 3.3V power supply

### Optional Components
1. **Voltage Divider** (if using 5V sensor with 3.3V logic)
   - 2 resistors (1kΩ and 2kΩ) for ECHO pin
   - Not needed if sensor operates at 3.3V

2. **Enclosure**
   - 3D printed or purchased case
   - Waterproof if installing outdoors

3. **Mounting Hardware**
   - Screws, brackets, or adhesive
   - For securing sensor to tank

## Installation Steps

### Step 1: Prepare the Sensor
1. **Check Sensor Voltage**
   - Most HC-SR04 sensors work with 3.3V
   - If not, you may need a voltage divider for the ECHO pin

2. **Test Sensor** (optional)
   - Connect to Arduino Uno first for testing
   - Verify sensor is working correctly

### Step 2: Connect Components
1. **Power Connections**
   - Connect Lolin D1 Mini 3.3V to HC-SR04 VCC
   - Connect Lolin D1 Mini GND to HC-SR04 GND

2. **Signal Connections**
   - Connect Lolin D1 Mini D1 (GPIO5) to HC-SR04 TRIG
   - Connect Lolin D1 Mini D2 (GPIO4) to HC-SR04 ECHO

3. **Verify Connections**
   - Double-check all connections
   - Ensure no loose wires

### Step 3: Mount Sensor
1. **Position Sensor**
   - Mount sensor at the top of the tank
   - Ensure it points downward toward water surface
   - Keep sensor level and secure

2. **Calculate Distance**
   - Measure distance from sensor to tank bottom
   - Update `TANK_HEIGHT_CM` in code accordingly

### Step 4: Power and Test
1. **Connect Power**
   - Connect USB cable to Lolin D1 Mini
   - Power up the device

2. **Monitor Serial Output**
   - Open Serial Monitor at 115200 baud
   - Check for initialization messages
   - Verify sensor readings

## Troubleshooting Hardware

### Common Issues

1. **No Sensor Readings**
   - Check power connections (VCC and GND)
   - Verify TRIG and ECHO connections
   - Ensure sensor is properly positioned

2. **Inconsistent Readings**
   - Check for loose connections
   - Ensure sensor is stable and level
   - Verify tank surface is calm (no waves)

3. **Out of Range Readings**
   - Check `MIN_DISTANCE_CM` and `MAX_DISTANCE_CM` values
   - Verify tank height configuration
   - Ensure sensor is within detection range

4. **Power Issues**
   - Use stable power supply
   - Check USB cable quality
   - Ensure adequate current supply

### Testing Procedure

1. **Basic Function Test**
   ```cpp
   // Simple test code for Arduino Uno
   const int TRIG_PIN = 9;
   const int ECHO_PIN = 10;
   
   void setup() {
     Serial.begin(9600);
     pinMode(TRIG_PIN, OUTPUT);
     pinMode(ECHO_PIN, INPUT);
   }
   
   void loop() {
     digitalWrite(TRIG_PIN, LOW);
     delayMicroseconds(2);
     digitalWrite(TRIG_PIN, HIGH);
     delayMicroseconds(10);
     digitalWrite(TRIG_PIN, LOW);
     
     long duration = pulseIn(ECHO_PIN, HIGH);
     float distance = duration * 0.034 / 2;
     
     Serial.print("Distance: ");
     Serial.print(distance);
     Serial.println(" cm");
     
     delay(1000);
   }
   ```

2. **Range Test**
   - Test sensor at various distances
   - Verify accuracy within expected range
   - Check for any dead zones

## Safety Considerations

1. **Electrical Safety**
   - Use appropriate voltage levels
   - Avoid short circuits
   - Use proper insulation

2. **Water Safety**
   - Ensure sensor is waterproof if needed
   - Keep electronics away from water
   - Use appropriate mounting hardware

3. **Environmental**
   - Protect from extreme temperatures
   - Shield from direct sunlight if outdoors
   - Consider humidity protection

## Maintenance

1. **Regular Checks**
   - Inspect connections monthly
   - Clean sensor surface if needed
   - Check for corrosion

2. **Calibration**
   - Recalibrate if tank dimensions change
   - Verify readings periodically
   - Update code parameters as needed 