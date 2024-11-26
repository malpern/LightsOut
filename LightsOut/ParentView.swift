import SwiftUI
import FirebaseFirestore

struct ParentView: View {
    @State private var isOn: Bool = true
    @State private var selectedOption: Int = 1
    @State private var isLoading: Bool = true
    private let db = Firestore.firestore()

    private func fetchInitialState() {
        isLoading = true
        print("🔥 Firebase: Fetching initial state...")
        
        db.collection("settings").document("lights").getDocument { (document, error) in
            if let error = error {
                print("❌ Firebase Error: \(error)")
                isLoading = false
                return
            }

            if let document = document, document.exists {
                if let data = document.data() {
                    DispatchQueue.main.async {
                        self.isOn = data["isOn"] as? Bool ?? true
                        self.selectedOption = data["selectedOption"] as? Int ?? 1
                        print("✅ Firebase: Fetched state - lights are \(self.isOn ? "ON" : "OFF"), icon: \(self.selectedOption)")
                        self.isLoading = false
                    }
                }
            } else {
                print("📝 Firebase: No document found, creating initial state...")
                self.updateFirestoreState()
                self.isLoading = false
            }
        }
    }

    private func updateFirestoreState() {
        print("🔥 Firebase: Updating state - setting lights to \(isOn ? "ON" : "OFF"), icon: \(selectedOption)")
        
        db.collection("settings").document("lights").setData([
            "isOn": isOn,
            "selectedOption": selectedOption,
            "lastUpdated": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("❌ Firebase Error: \(error)")
            } else {
                print("✅ Firebase: Successfully updated state")
            }
        }
    }

    private var selectedIconName: String {
        let baseName = selectedOption == 1 ? "lightbulb" : "hand.wave"
        return isOn ? baseName : "\(baseName).fill"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: isOn ? [.red, .yellow] : [.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(.easeInOut, value: isOn)

            if isLoading {
                ProgressView()
            } else {
                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        Group {
                            Image(systemName: selectedIconName)
                                .renderingMode(.template)
                                .font(.system(size: 40))
                                .frame(width: 50, height: 50, alignment: .center)

                            Toggle("Lights out, Micah!", isOn: $isOn.onChange { _ in
                                updateFirestoreState()
                            })
                            .font(.system(size: 35))
                            .tint(.green)
                            .padding()
                            .animation(.easeInOut, value: isOn)
                        }
                        .modifier(ModifierShadow(isOn: isOn))
                        .foregroundColor(isOn ? .black : .white)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()

                    VStack {
                        Picker("Icon", selection: $selectedOption.onChange { _ in updateFirestoreState()
                        }) {
                            Image(systemName: "lightbulb").tag(1)
                            Image(systemName: "hand.wave").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        .background(isOn ? Color.clear : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .accentColor(isOn ? .black : .yellow)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            fetchInitialState()
        }
    }
}

struct ModifierShadow: ViewModifier {
    let isOn: Bool

    func body(content: Content) -> some View {
        content
            .shadow(color: isOn ? .clear : .white, radius: isOn ? 0 : 8)
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
