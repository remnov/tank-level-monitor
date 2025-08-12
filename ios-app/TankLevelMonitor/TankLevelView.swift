import SwiftUI

struct TankLevelView: View {
    let waterLevel: Double
    let percentage: Double
    
    var body: some View {
        VStack(spacing: 20) {
            // Tank Visualization
            ZStack {
                // Tank outline
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 3)
                    .frame(width: 200, height: 300)
                
                // Water level
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 17)
                        .fill(waterColor)
                        .frame(width: 194, height: max(0, 294 * CGFloat(percentage / 100)))
                        .animation(.easeInOut(duration: 0.5), value: percentage)
                }
                .frame(width: 200, height: 300)
                
                // Percentage text overlay
                VStack {
                    Spacer()
                    Text("\(Int(percentage))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    Spacer()
                }
                .frame(width: 200, height: 300)
            }
            
            // Level details
            VStack(spacing: 10) {
                Text("\(String(format: "%.1f", waterLevel)) cm")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Water Level")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Level indicator
            HStack(spacing: 20) {
                VStack {
                    Text("Empty")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Circle()
                        .fill(percentage < 20 ? Color.red : Color.gray)
                        .frame(width: 8, height: 8)
                }
                
                VStack {
                    Text("Low")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Circle()
                        .fill(percentage >= 20 && percentage < 50 ? Color.orange : Color.gray)
                        .frame(width: 8, height: 8)
                }
                
                VStack {
                    Text("Good")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Circle()
                        .fill(percentage >= 50 && percentage < 80 ? Color.yellow : Color.gray)
                        .frame(width: 8, height: 8)
                }
                
                VStack {
                    Text("Full")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Circle()
                        .fill(percentage >= 80 ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
    
    private var waterColor: Color {
        if percentage < 20 {
            return Color.red.opacity(0.7)
        } else if percentage < 50 {
            return Color.orange.opacity(0.7)
        } else if percentage < 80 {
            return Color.blue.opacity(0.7)
        } else {
            return Color.green.opacity(0.7)
        }
    }
}

struct TankLevelView_Previews: PreviewProvider {
    static var previews: some View {
        TankLevelView(waterLevel: 75.0, percentage: 75.0)
    }
} 