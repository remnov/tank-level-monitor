import Foundation
import Combine

class TankLevelService: ObservableObject {
    @Published var waterLevel: Double = 0.0
    @Published var percentage: Double = 0.0
    @Published var isConnected: Bool = false
    
    private var timer: Timer?
    private var deviceIP: String = "192.168.1.100" // Default IP, will be configurable
    
    struct TankLevelResponse: Codable {
        let waterLevel: Double
        let percentage: Double
        let timestamp: UInt64
        let status: String
    }
    
    struct DeviceStatus: Codable {
        let status: String
        let uptime: UInt64
        let wifiRSSI: Int
        let freeHeap: UInt32
    }
    
    func startMonitoring() {
        // Load saved IP address
        if let savedIP = UserDefaults.standard.string(forKey: "deviceIP") {
            deviceIP = savedIP
        }
        
        // Start timer to fetch data every 5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.fetchTankLevel()
        }
        
        // Fetch initial data
        fetchTankLevel()
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateDeviceIP(_ newIP: String) {
        deviceIP = newIP
        UserDefaults.standard.set(newIP, forKey: "deviceIP")
        fetchTankLevel() // Test connection immediately
    }
    
    private func fetchTankLevel() {
        guard let url = URL(string: "http://\(deviceIP)/api/level") else {
            DispatchQueue.main.async {
                self.isConnected = false
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching tank level: \(error)")
                    self?.isConnected = false
                    return
                }
                
                guard let data = data else {
                    self?.isConnected = false
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(TankLevelResponse.self, from: data)
                    self?.waterLevel = response.waterLevel
                    self?.percentage = response.percentage
                    self?.isConnected = true
                } catch {
                    print("Error decoding response: \(error)")
                    self?.isConnected = false
                }
            }
        }
        
        task.resume()
    }
    
    func fetchDeviceStatus(completion: @escaping (DeviceStatus?) -> Void) {
        guard let url = URL(string: "http://\(deviceIP)/api/status") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching device status: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let status = try JSONDecoder().decode(DeviceStatus.self, from: data)
                completion(status)
            } catch {
                print("Error decoding status: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func testConnection(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://\(deviceIP)/api/status") else {
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    completion(httpResponse.statusCode == 200)
                } else {
                    completion(false)
                }
            }
        }
        
        task.resume()
    }
} 