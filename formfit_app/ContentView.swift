import SwiftUI

struct ContentView: View {
    // Original text content
    let words = ["It's", "You", "vs", "You."]
    @State private var visibleWords = [false, false, false, false]
    @State private var showPrice = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Spacer() // Push content to bottom half
                
                // Text container - positioned in bottom left
                VStack(alignment: .leading, spacing: 16) {
                    // Animated words
                    HStack(spacing: 8) {
                        ForEach(0..<words.count, id: \.self) { index in
                            Text(words[index])
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(visibleWords[index] ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.5), value: visibleWords[index])
                        }
                    }
                    
                    // Price text
                    Text("From € 5,49 per month")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .opacity(showPrice ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5), value: showPrice)
                    
                    // Button
                    if showButton {
                        Button(action: {
                            print("Button tapped")
                        }) {
                            HStack {
                                Image(systemName: "arrow.right")
                                Text("Try it for free")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.black)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                            )
                        }
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.5), value: showButton)
                    }
                }
                .padding(.leading, 16) // Exactly 16 pixels from the left
                .padding(.bottom, 160) // Adjust to position in the bottom left
                .frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                Spacer().frame(height: 80) // Space at the bottom
            }
            
        }
        .onAppear {
            animateWords()
        }
    }
    
    private func animateWords() {
        // Animate each word with a delay and haptic feedback
        for i in 0..<words.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.8) {
                triggerHapticFeedback() // Haptic feedback for each word
                withAnimation {
                    visibleWords[i] = true
                }
            }
        }
        
        // Show price after words
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(words.count) * 0.8) {
            withAnimation {
                showPrice = true
            }
        }
        
        // Show button at the end
        DispatchQueue.main.asyncAfter(deadline: .now() + (Double(words.count) * 0.8) + 0.5) {
            withAnimation {
                showButton = true
            }
        }
    }
    
    private func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
