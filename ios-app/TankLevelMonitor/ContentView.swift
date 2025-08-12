import SwiftUI

struct ContentView: View {
    @StateObject private var tankLevelService = TankLevelService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Tank Level Monitor")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Tank Level Display
                TankLevelView(waterLevel: tankLevelService.waterLevel, 
                            percentage: tankLevelService.percentage)
                
                // Connection Status
                HStack {
                    Circle()
                        .fill(tankLevelService.isConnected ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    Text(tankLevelService.isConnected ? "Connected" : "Disconnected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Settings Button
                NavigationLink(destination: SettingsView(tankLevelService: tankLevelService)) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .onAppear {
            tankLevelService.startMonitoring()
        }
        .onDisappear {
            tankLevelService.stopMonitoring()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 