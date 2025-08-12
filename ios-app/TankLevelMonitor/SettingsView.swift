import SwiftUI

struct SettingsView: View {
    @ObservedObject var tankLevelService: TankLevelService
    @State private var deviceIP: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isTestingConnection = false
    
    var body: some View {
        Form {
            Section(header: Text("Device Configuration")) {
                HStack {
                    Text("Device IP Address")
                    Spacer()
                    TextField("192.168.1.100", text: $deviceIP)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Button(action: testConnection) {
                    HStack {
                        if isTestingConnection {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "network")
                        }
                        Text("Test Connection")
                    }
                }
                .disabled(deviceIP.isEmpty || isTestingConnection)
                
                Button(action: saveSettings) {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("Save Settings")
                    }
                }
                .disabled(deviceIP.isEmpty)
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Device Status")
                    Spacer()
                    Text(tankLevelService.isConnected ? "Connected" : "Disconnected")
                        .foregroundColor(tankLevelService.isConnected ? .green : .red)
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            deviceIP = UserDefaults.standard.string(forKey: "deviceIP") ?? "192.168.1.100"
        }
        .alert("Connection Test", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func testConnection() {
        isTestingConnection = true
        
        tankLevelService.testConnection { success in
            DispatchQueue.main.async {
                isTestingConnection = false
                alertMessage = success ? "Connection successful!" : "Connection failed. Please check the IP address and ensure the device is on the same network."
                showingAlert = true
            }
        }
    }
    
    private func saveSettings() {
        tankLevelService.updateDeviceIP(deviceIP)
        alertMessage = "Settings saved successfully!"
        showingAlert = true
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(tankLevelService: TankLevelService())
        }
    }
} 