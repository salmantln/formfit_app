import SwiftUI

struct ActivityView: View {
    // State for period selection
    @State private var selectedPeriod = 0
    let periods = ["This week", "This month", "All time"]
    
    // Current date information
    @State private var currentDate = Date()
    @State private var weekDates: [Date] = []
    
    // Workout stats - will be calculated based on data
    @State private var workoutCount = 3
    @State private var totalMinutes = 0
    
    // Exercise data
    let topExercises = [
        Exercise(name: "Jumping Jacks", value: "143", unit: "reps"),
        Exercise(name: "Forward Punches", value: "3", unit: "minutes"),
        Exercise(name: "Squat Front Kicks", value: "29", unit: "reps"),
        Exercise(name: "Jog In Place", value: "2", unit: "minutes"),
        Exercise(name: "Reverse Lunges", value: "9", unit: "reps")
    ]
    
    // Daily activity data - will be updated with real dates
    @State private var dailyActivity: [DayActivity] = []
    
    // Workout category data
    let workoutCategories = [
        WorkoutCategory1(name: "Cardio", count: 2, color: .orange),
        WorkoutCategory1(name: "Full Body", count: 1, color: .blue),
        WorkoutCategory1(name: "Legs & Glutes", count: 0, color: .purple),
        WorkoutCategory1(name: "Upper Body", count: 0, color: .red)
    ]
    
    init() {
        // Initialize with current date info - this will happen when view is created
        _currentDate = State(initialValue: Date())
        _weekDates = State(initialValue: [])
        _dailyActivity = State(initialValue: [])
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Fixed Header section
            VStack(alignment: .leading, spacing: 12) {
                Text("Activity")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Period selector
                HStack {
                    ForEach(0..<periods.count, id: \.self) { index in
                        Button(action: {
                            selectedPeriod = index
                            updateDisplayData()
                        }) {
                            VStack(spacing: 8) {
                                Text(periods[index])
                                    .foregroundColor(selectedPeriod == index ? .black : .gray)
                                
                                // Underline for selected period
                                if selectedPeriod == index {
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.black)
                                } else {
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.clear)
                                }
                            }
                        }
                        
                        if index < periods.count - 1 {
                            Spacer()
                        }
                    }
                }
            }
            .padding([.horizontal, .top])
            .background(Color(UIColor.systemBackground))
            .zIndex(1) // Ensure header stays on top
            
            // Scrollable content
            ScrollView {
                VStack(spacing: 20) {
                    // Add some spacing to separate from header
                    Spacer().frame(height: 10)
                    
                    // Workout & Total Time summary
                    HStack(spacing: 15) {
                        // Workouts
                        SummaryCard(
                            icon: "figure.walk",
                            title: "Workouts",
                            value: "\(workoutCount)"
                        )
                        
                        // Total time
                        SummaryCard(
                            icon: "timer",
                            title: "Total time",
                            value: "\(totalMinutes)m"
                        )
                    }
                    .padding(.horizontal)
                    
                  
                    // Daily activity chart
                                       VStack(alignment: .leading, spacing: 8) {
                                           Text("Total time")
                                               .font(.headline)
                                               .fontWeight(.bold)
                                           
                                           Text("minutes per day")
                                               .font(.subheadline)
                                               .foregroundColor(.gray)
                                           
                                           HStack(alignment: .bottom, spacing: 0) {
                                               ForEach(dailyActivity) { day in
                                                   VStack(spacing: 6) {
                                                       // Minutes value positioned above the bar
                                                       if day.minutes > 0 {
                                                           Text("\(day.minutes)")
                                                               .font(.caption)
                                                               .foregroundColor(.black)
                                                       } else {
                                                           // Empty space holder for alignment
                                                           Text("")
                                                               .font(.caption)
                                                               .foregroundColor(.clear)
                                                       }
                                                       
                                                       // Activity bar
                                                       ZStack(alignment: .bottom) {
                                                           Rectangle()
                                                               .frame(width: 30, height: 120)
                                                               .foregroundColor(.clear)
                                                           
                                                           if day.minutes > 0 {
                                                               Rectangle()
                                                                   .frame(width: 24, height: CGFloat(day.minutes) * 15)
                                                                   .foregroundColor(.orange)
                                                                   .cornerRadius(4)
                                                           }
                                                       }
                                                       
                                                       // Day label
                                                       Text(day.day)
                                                           .font(.caption)
                                                           .foregroundColor(.gray)
                                                           .multilineTextAlignment(.center)
                                                   }
                                                   .frame(maxWidth: .infinity)
                                               }
                                           }
                                       }
                                       .padding()
                                       .background(Color.white)
                                       .cornerRadius(12)
                                       .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                       .padding(.horizontal)
                    
                    // Workout categories (circular chart)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Workouts")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        // Circular progress with total in center (matching the image)
                        ZStack {
                            // Total workouts in center
                            VStack(spacing: 2) {
                                Text("\(workoutCount)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text("workouts total")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            // Circle chart
                            CircleChart(categories: workoutCategories, total: workoutCount)
                                .frame(width: 180, height: 180)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        
                        // Category legend
                        VStack(spacing: 12) {
                            ForEach(workoutCategories) { category in
                                HStack {
                                    Circle()
                                        .fill(category.color)
                                        .frame(width: 10, height: 10)
                                    
                                    Text(category.name)
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    Text("\(category.count) workout\(category.count == 1 ? "" : "s")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Top exercises
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Top exercises")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                HStack(spacing: 4) {
                                    Text("View all")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        ForEach(topExercises) { exercise in
                            HStack {
                                Text(exercise.name)
                                    .font(.body)
                                
                                Spacer()
                                
                                Text("\(exercise.value) \(exercise.unit)")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                            
                            if exercise.id != topExercises.last?.id {
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
        }
        .onAppear {
            generateCurrentWeekDates()
            updateDisplayData()
        }
    }
    
    // Generate dates for the current week with today at the end
    private func generateCurrentWeekDates() {
        let calendar = Calendar.current
        let today = Date()
        
        // For this app, we want today to be the rightmost day
        // So we'll go back 6 days from today to get the start date
        
        var dates: [Date] = []
        for i in (0...6).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                dates.append(date)
            }
        }
        
        // Now dates array has dates ordered with today at the end
        self.weekDates = dates
    }
    
    // Update display data based on selected period
    private func updateDisplayData() {
        // For demo purposes, we'll only handle "This week" with real data
        // In a real app, you would fetch data for the selected period from a database or API
        
        if selectedPeriod == 0 { // This week
            updateThisWeekData()
        } else if selectedPeriod == 1 { // This month
            // Placeholder function - would implement real data
            updateThisMonthData()
        } else { // All time
            // Placeholder function - would implement real data
            updateAllTimeData()
        }
    }
    
    // Update data for "This week" view
    private func updateThisWeekData() {
        let calendar = Calendar.current
        let today = Date()
        
        var activities: [DayActivity] = []
        var totalMins = 0
        
        // Format the weekday labels and add sample data
        // In a real app, you would fetch actual workout data for each date
        for (index, date) in weekDates.enumerated() {
            let isToday = calendar.isDate(date, inSameDayAs: today)
            let dayNumber = calendar.component(.day, from: date)
            
            // Format month as a 3-letter abbreviation
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM"
            let monthAbbr = monthFormatter.string(from: date).uppercased()
            
            // Create day label
            let dayLabel = isToday ? "TODAY\n": "\(dayNumber)\n\(monthAbbr)"
            
            // For demo, assign workout minutes based on day of week
            // March 11, 2025 is a Tuesday (assuming standard calendar)
            // Give some workout minutes to current day and day before
            var minutes = 0
            
            if isToday {
                minutes = 5 // Today (March 11)
            } else if calendar.isDate(date, equalTo: today, toGranularity: .day) {
                minutes = 0 // Safety check
            } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                      calendar.isDate(date, inSameDayAs: yesterday) {
                minutes = 7 // Yesterday (March 10)
            }
            
            totalMins += minutes
            activities.append(DayActivity(day: dayLabel, minutes: minutes))
        }
        
        // Update the UI data
        self.dailyActivity = activities
        self.totalMinutes = totalMins
    }
    
    // Placeholder functions for other time periods
    private func updateThisMonthData() {
        // For demo, just showing a simplified version
        self.totalMinutes = 25
        // Would need to generate month day activities here
    }
    
    private func updateAllTimeData() {
        // For demo, just showing a simplified version
        self.totalMinutes = 87
        // Would need to generate all-time activities here
    }
}

// Summary card component
struct SummaryCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.black)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Circle chart for workout categories
struct CircleChart: View {
    let categories: [WorkoutCategory1]
    let total: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
            
            ForEach(0..<categories.count, id: \.self) { index in
                let category = categories[index]
                
                // Only draw segments for categories with workouts
                if category.count > 0 {
                    CircleSegment(
                        index: index,
                        count: category.count,
                        total: total,
                        categories: categories,
                        color: category.color
                    )
                }
            }
        }
    }
}

// Individual segment for the circle chart
struct CircleSegment: View {
    let index: Int
    let count: Int
    let total: Int
    let categories: [WorkoutCategory1]
    let color: Color
    
    private var startAngle: Double {
        var sum = 0
        for i in 0..<categories.count {
            if i < index && categories[i].count > 0 {
                sum += categories[i].count
            }
        }
        return Double(sum) / Double(total) * 360.0 - 90
    }
    
    private var endAngle: Double {
        var sum = 0
        for i in 0..<categories.count {
            if i <= index && categories[i].count > 0 {
                sum += categories[i].count
            }
        }
        return Double(sum) / Double(total) * 360.0 - 90
    }
    
    var body: some View {
        Path { path in
            path.addArc(
                center: CGPoint(x: 90, y: 90),
                radius: 80,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: 90, y: 90))
            path.closeSubpath()
        }
        .fill(color)
        .overlay(
            Path { path in
                path.addArc(
                    center: CGPoint(x: 90, y: 90),
                    radius: 70,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false
                )
                path.addLine(to: CGPoint(x: 90, y: 90))
                path.closeSubpath()
            }
                .fill(Color.white)
        )
    }
}

// Model for exercise
struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let unit: String
}

// Model for workout categories
struct WorkoutCategory1: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let color: Color
}

// Model for daily activity
struct DayActivity: Identifiable {
    let id = UUID()
    let day: String
    let minutes: Int
}

// This class is no longer used - we're using WorkoutCategory1 instead
// Keeping the declaration to maintain reference compatibility

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
