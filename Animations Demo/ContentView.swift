//
//  ContentView.swift
//  Animations Demo
//
//  Created by Arjav Lad on 2/7/25.
//

import SwiftUI

struct ContentView: View {
    // State variables to control the animations
    @State private var phase: Double = 0
    @State private var numberOfCircles: Int = 16
    
    // Computed property to ensure even number of circles and calculate angles
    var angles: [Double] {
        let count = numberOfCircles + (numberOfCircles % 2) // Ensure even number
        return Array(stride(from: 0, to: 360, by: 360.0/Double(count)))
    }
    
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60fps timer
    
    var body: some View {
        VStack {
            // Slider to control number of circles
            Slider(
                value: Binding(
                    get: { Double(numberOfCircles) },
                    set: { numberOfCircles = max(2, Int($0)) }
                ),
                in: 2...32,
                step: 2
            )
            .padding()
            Text("Number of circles: \(numberOfCircles)")
            
            ZStack {
                // Big circle
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 300, height: 300)
                
                // Debug lines showing oscillation paths
                ForEach(angles, id: \.self) { angle in
                    Rectangle()
                        .fill(Color.gray.opacity(0))
                        .frame(width: 270, height: 1.5)
                        .rotationEffect(.degrees(angle))
                }
                
                // Oscillating circles
                ForEach(Array(angles.enumerated()), id: \.element) { index, angle in
                    Circle()
                        .fill(Color.red)
                        .frame(width: 30, height: 30)
                        .offset(x: calculateOffset(for: angle))
                        .rotationEffect(.degrees(angle))
                }
            }
        }
        .onReceive(timer) { _ in
            // Update phase continuously
            phase += 2 // Adjust this value to control speed
            if phase >= 360 {
                phase = 0
            }
        }
        .padding()
    }
    
    private func calculateOffset(for angle: Double) -> CGFloat {
        let radius: Double = 135
        let phaseRadians = (phase - angle) * .pi / 180
        return radius * cos(phaseRadians)
    }
}

#Preview {
    ContentView()
}
