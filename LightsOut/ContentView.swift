//
//  ContentView.swift
//  LightsOut
//
//  Created by Micah Alpern on 11/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isOn: Bool = true

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(
                colors: isOn ? [.red, .yellow] : [.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(.easeInOut, value: isOn)

            VStack {
                Image(systemName:  isOn ? "lightbulb" : "lightbulb.fill")
                    .renderingMode(.template)
                    .foregroundColor(isOn ? .black : .white)
                    .font(.system(size: 40))
                    .shadow(color: isOn ? .clear : .white, radius: isOn ? 0 : 10)
                    .shadow(color: isOn ? .clear : .white, radius: isOn ? 0 : 10)

                
                Toggle("Lights out, Micah!", isOn: $isOn)
                    .font(.system(size: 35))
                    .foregroundColor(isOn ? .black : .white)
                    .tint(.green) // Optional: Change toggle color
                    .padding() // Add some padding to the toggle
                    .shadow(color: isOn ? .clear : .white, radius: isOn ? 0 : 10)
                    .shadow(color: isOn ? .clear : .white, radius: isOn ? 0 : 10)
                    .sensoryFeedback(.selection, trigger: isOn)
                    .animation(.easeInOut, value: isOn)

                }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
