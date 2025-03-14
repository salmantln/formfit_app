import SwiftUI

struct WorkoutCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct WorkoutCategoryView: View {
    // Workout categories
    private let categories: [WorkoutCategory] = [
        WorkoutCategory(name: "Custom"),
        WorkoutCategory(name: "Push"),
        WorkoutCategory(name: "Pull"),
        WorkoutCategory(name: "Full body"),
        WorkoutCategory(name: "Upper body"),
        WorkoutCategory(name: "Legs"),
        WorkoutCategory(name: "Glutes"),
        WorkoutCategory(name: "Back"),
        WorkoutCategory(name: "Chest"),
        WorkoutCategory(name: "Shoulders"),
        WorkoutCategory(name: "Bicep"),
        WorkoutCategory(name: "Tricep"),
        WorkoutCategory(name: "Core"),
        WorkoutCategory(name: "Abs"),
        WorkoutCategory(name: "Stretching"),
    ]
    
    // Currently selected category index
    @State private var selectedIndex: Int? = 0 // Default to "Custom"
    
    // Flag to track if selection changed via scroll
    @State private var selectionChangedViaScroll = false
    
    // Create haptic feedback generator
    @State private var hapticImpact = UIImpactFeedbackGenerator(style: .medium)
    
    // Item height for consistency
    private let itemHeight: CGFloat = 70
    
    // How many items to show (total visible items will be this value)
    private let menuHeightMultiplier: CGFloat = 6 // Increased from 5 to make it larger
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Top section with back button and progress bar
                    topSection
                        .padding(.bottom, 10)
                    
                    // Optional spacer to push content down
                    Spacer(minLength: 20)
                    
                    // Main scrollable picker - now expanded
                    pickerSection
                        .frame(height: geometry.size.height * 0.65)
                    
                    // Bottom section with creation text
                    bottomSection
                        .padding(.top, 10)
                }
            }
        }
        .onAppear {
            // Prepare haptic engine when view appears
            hapticImpact.prepare()
        }
    }
    
    // MARK: - Component Views
    
    // Top section with back button and progress bar
    private var topSection: some View {
        VStack(spacing: 20) {
            // Back button
            HStack {
                Image(systemName: "arrow.down")
                    .font(.title2)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            // Progress bar
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 4)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // Picker section using scrollPosition API with improved edge handling
    private var pickerSection: some View {
        let itemsCountAbove = Double(Int((menuHeightMultiplier - 1)))
        
        return ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    // Add extra invisible items before the first real item to fix edge scrolling
                    Color.clear
                        .frame(height: 1)
                        .id("top-spacer")
                    
                    ForEach(0..<categories.count, id: \.self) { index in
                        let category = categories[index]
                        
                        HStack {
                            // Category name
                            Text(category.name)
                                .font(.system(size: 38, weight: .medium))
                                .foregroundColor(selectedIndex == index ? .white : .gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Arrow indicator (only for selected item)
                            if selectedIndex == index {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.black)
                                    )
                            }
                        }
                        .id(index)
                        .frame(height: itemHeight)
                        .padding(.horizontal, 20)
                        // Add divider after each item except the last
                        .overlay(
                            VStack {
                                Spacer()
                                if index < categories.count - 1 {
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                }
                            }
                        )
                        // Make the entire row tappable
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // If tapping a different item than the currently selected one
                            if selectedIndex != index {
                                // Trigger medium haptic feedback
                                hapticImpact.impactOccurred()
                                
                                // Update selection
                                selectedIndex = index
                                
                                // Scroll to the selected item
                                withAnimation {
                                    scrollProxy.scrollTo(index, anchor: .center)
                                }
                            }
                        }
                    }
                    
                    // Add extra invisible item after the last real item to fix edge scrolling
                    Color.clear
                        .frame(height: 1)
                        .id("bottom-spacer")
                }
                .scrollTargetLayout()
                .padding(.vertical, itemHeight * itemsCountAbove)
            }
            .scrollPosition(id: $selectedIndex, anchor: .center)
            // Track when selection changes due to scrolling
            .onChange(of: selectedIndex) { oldValue, newValue in
                // Only trigger haptics if this wasn't from a tap (which already has haptics)
                if !selectionChangedViaScroll && oldValue != newValue {
                    selectionChangedViaScroll = true
                    
                    // Trigger light haptic feedback on scroll selection change
                    hapticImpact.impactOccurred(intensity: 0.7)
                    
                    // Reset the flag after a small delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        selectionChangedViaScroll = false
                    }
                }
            }
            .padding(.vertical, (Int(menuHeightMultiplier) % 2 == 0) ? itemHeight * 0.5 : 0)
            .onAppear {
                // Initial scroll to selected index - do this with a slight delay
                // to ensure the view is fully rendered
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let index = selectedIndex {
                        withAnimation {
                            scrollProxy.scrollTo(index, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    // Bottom section with creation text
    private var bottomSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let index = selectedIndex, index < categories.count {
                let category = categories[index]
                
                Text("Create a \(category.name) workout")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                
                if category.name == "Custom" || category.name == "Push" || category.name == "Pull" {
                    Text("We'll help you pick exercises later")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                } else {
                    Text("Exercises for muscles in \(category.name.lowercased())")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            } else {
                Text("Create a workout")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("We'll help you pick exercises later")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.black)
    }
}

// MARK: - Preview
struct WorkoutCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCategoryView()
    }
}
