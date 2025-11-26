//
//  MainView.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import SwiftUI

struct MainView: View {
    @StateObject private var dataService = DataService.shared
    @State private var showSettings = false
    @State private var selectedLevel: Int?
    
    var motivationalPhrase: String {
        let puzzleCount = dataService.playerProgress.completedPuzzles.count
        let totalPuzzles = Puzzle.allPuzzles.count
        
        if puzzleCount == 0 {
            return "Ready to Challenge Your Mind? 🧠"
        } else if puzzleCount < 5 {
            return "Great Start! Keep Going! 💪"
        } else if puzzleCount < 10 {
            return "You're On Fire! 🔥"
        } else if puzzleCount < 20 {
            return "Brilliant Mind at Work! ✨"
        } else if puzzleCount < 30 {
            return "Unstoppable Genius! 🚀"
        } else if puzzleCount < 40 {
            return "Almost There, Champion! 🏆"
        } else if puzzleCount == totalPuzzles {
            return "Legendary Puzzle Master! 👑"
        } else {
            return "Keep Pushing Forward! 💫"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color(hex: "02102b")
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            // Header Stats
                            VStack(spacing: 15) {
                                Text(motivationalPhrase)
                                    .font(.system(size: min(geometry.size.width * 0.06, 24), weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(2)
                                
                                // Adaptive layout for stats
                                if geometry.size.width < 400 {
                                    // Vertical layout for small screens
                                    VStack(spacing: 15) {
                                        StatCard(
                                            icon: "star.fill",
                                            value: "\(dataService.playerProgress.totalPoints)",
                                            label: "Points"
                                        )
                                        
                                        StatCard(
                                            icon: "flag.fill",
                                            value: "\(dataService.playerProgress.currentLevel)",
                                            label: "Level"
                                        )
                                        
                                        StatCard(
                                            icon: "checkmark.circle.fill",
                                            value: "\(dataService.playerProgress.completedPuzzles.count)",
                                            label: "Solved"
                                        )
                                    }
                                    .padding(.horizontal)
                                } else {
                                    // Horizontal layout for larger screens
                                    HStack(spacing: min(geometry.size.width * 0.05, 30)) {
                                        StatCard(
                                            icon: "star.fill",
                                            value: "\(dataService.playerProgress.totalPoints)",
                                            label: "Points"
                                        )
                                        
                                        StatCard(
                                            icon: "flag.fill",
                                            value: "\(dataService.playerProgress.currentLevel)",
                                            label: "Level"
                                        )
                                        
                                        StatCard(
                                            icon: "checkmark.circle.fill",
                                            value: "\(dataService.playerProgress.completedPuzzles.count)",
                                            label: "Solved"
                                        )
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top, 20)
                        
                            // Levels Section
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Levels")
                                    .font(.system(size: min(geometry.size.width * 0.06, 24), weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                // Adaptive grid for levels
                                if geometry.size.width > 700 {
                                    // Two column layout for landscape/iPad
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                        ForEach(1...8, id: \.self) { level in
                                            LevelCard(
                                                level: level,
                                                isUnlocked: dataService.isLevelUnlocked(level),
                                                puzzles: dataService.getPuzzlesForLevel(level),
                                                completedPuzzles: dataService.playerProgress.completedPuzzles
                                            )
                                            .onTapGesture {
                                                if dataService.isLevelUnlocked(level) {
                                                    selectedLevel = level
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                } else {
                                    // Single column for portrait/small screens
                                    ForEach(1...8, id: \.self) { level in
                                        LevelCard(
                                            level: level,
                                            isUnlocked: dataService.isLevelUnlocked(level),
                                            puzzles: dataService.getPuzzlesForLevel(level),
                                            completedPuzzles: dataService.playerProgress.completedPuzzles
                                        )
                                        .onTapGesture {
                                            if dataService.isLevelUnlocked(level) {
                                                selectedLevel = level
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 20)
                        
                            // Achievements Section
                            if !dataService.playerProgress.achievements.isEmpty {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Achievements")
                                        .font(.system(size: min(geometry.size.width * 0.06, 24), weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 15) {
                                            ForEach(dataService.playerProgress.achievements) { achievement in
                                                AchievementCard(achievement: achievement)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.top, 20)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                
                // Settings button
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(hex: "ffbe00"))
                                .padding()
                                .background(Color(hex: "0a1a3b"))
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    Spacer()
                }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(item: $selectedLevel) { level in
                    LevelDetailView(level: level)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "ffbe00"))
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(12)
    }
}

struct LevelCard: View {
    let level: Int
    let isUnlocked: Bool
    let puzzles: [Puzzle]
    let completedPuzzles: [String]
    
    var completedCount: Int {
        puzzles.filter { completedPuzzles.contains($0.id) }.count
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color(hex: "bd0e1b") : Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                if isUnlocked {
                    Text("\(level)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Level \(level)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(completedCount)/\(puzzles.count) puzzles completed")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                if isUnlocked {
                    ProgressBar(value: Double(completedCount) / Double(max(puzzles.count, 1)))
                        .frame(height: 6)
                }
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "ffbe00"))
            }
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(12)
        .padding(.horizontal)
        .opacity(isUnlocked ? 1.0 : 0.5)
    }
}

struct ProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .cornerRadius(3)
                
                Rectangle()
                    .fill(Color(hex: "ffbe00"))
                    .frame(width: geometry.size.width * CGFloat(value))
                    .cornerRadius(3)
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: achievement.icon)
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "ffbe00"))
            
            Text(achievement.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Text(achievement.description)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(width: 150)
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(12)
    }
}

// Make Int identifiable for sheet presentation
extension Int: Identifiable {
    public var id: Int { self }
}

