//
//  ContentView.swift
//  LightsOut
//
//  Created by Micah Alpern on 11/21/24.
//

import SwiftUI

struct ParentView: View {
    @State private var isOn: Bool = true
    @State private var selectedOption: Int = 1 // Picker selection

    // Computed property to determine the icon name
    private var selectedIconName: String {
        let baseName = selectedOption == 1 ? "lightbulb" : "hand.wave"
        return isOn ? baseName : "\(baseName).fill"
    }

    // Reusable shadow modifier based on state
    private var shadowStyle: some ViewModifier {
        ModifierShadow(isOn: isOn)
    }

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: isOn ? [.red, .yellow] : [.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(.easeInOut, value: isOn)

            VStack {
                Spacer()

                // Center the icon and toggle
                VStack(spacing: 20) {
                    Group {
                        Image(systemName: selectedIconName)
                            .renderingMode(.template)
                            .font(.system(size: 40))
                            .frame(width: 50, height: 50, alignment: .center)
                        
                        Toggle("Lights out, Micah!", isOn: $isOn)
                            .font(.system(size: 35))
                            .tint(.green)
                            .padding()
                            .sensoryFeedback(.selection, trigger: isOn)
                            .animation(.easeInOut, value: isOn)
                    }
                    .modifier(shadowStyle)
                    .foregroundColor(isOn ? .black : .white)

                }
                .frame(maxWidth: .infinity) // Center horizontally

                Spacer()

                // Keep the Picker at the bottom
                VStack {
                    Picker("Icon", selection: $selectedOption) {
                        Image(systemName: "lightbulb").tag(1)
                        Image(systemName: "hand.wave").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .background(isOn ? Color.clear : Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .accentColor(isOn ? .black : .yellow)
                }
                .padding(.bottom, 20) // Add padding to avoid clipping with the bottom edge
            }
        }
    }
}

// Reusable shadow modifier
struct ModifierShadow: ViewModifier {
    let isOn: Bool

    func body(content: Content) -> some View {
        content
            .shadow(color: isOn ? .clear : .white, radius: isOn ? 0 : 8)
            .shadow(color: isOn ? .clear : .white, radius: isOn ? 0 : 8)
    }
}

#Preview {
    ParentView()
}
