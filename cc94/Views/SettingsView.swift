//
//  SettingsView.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @StateObject private var dataService = DataService.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "02102b")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Gameplay Settings
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Gameplay")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            SettingToggle(
                                icon: "hand.tap.fill",
                                title: "Haptic Feedback",
                                isOn: $viewModel.hapticFeedback
                            )
                            
                            // Difficulty Selector
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 12) {
                                    Image(systemName: "gauge.medium")
                                        .font(.system(size: 22))
                                        .foregroundColor(Color(hex: "ffbe00"))
                                        .frame(width: 30)
                                    
                                    Text("Difficulty Preference")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Picker("Difficulty", selection: $viewModel.difficulty) {
                                    ForEach(viewModel.difficultyOptions, id: \.self) { option in
                                        Text(option.capitalized).tag(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .background(Color(hex: "0a1a3b"))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color(hex: "0a1a3b"))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Statistics
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Statistics")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 15) {
                                StatRow(
                                    label: "Total Points",
                                    value: "\(dataService.playerProgress.totalPoints)",
                                    icon: "star.fill"
                                )
                                
                                StatRow(
                                    label: "Current Level",
                                    value: "\(dataService.playerProgress.currentLevel)",
                                    icon: "flag.fill"
                                )
                                
                                StatRow(
                                    label: "Puzzles Solved",
                                    value: "\(dataService.playerProgress.completedPuzzles.count)/\(Puzzle.allPuzzles.count)",
                                    icon: "checkmark.circle.fill"
                                )
                                
                                StatRow(
                                    label: "Achievements",
                                    value: "\(dataService.playerProgress.achievements.count)",
                                    icon: "trophy.fill"
                                )
                                
                                if let lastPlayed = formatDate(dataService.playerProgress.lastPlayedDate) {
                                    StatRow(
                                        label: "Last Played",
                                        value: lastPlayed,
                                        icon: "clock.fill"
                                    )
                                }
                            }
                            .padding()
                            .background(Color(hex: "0a1a3b"))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Reset Game
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Game Data")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Button(action: {
                                viewModel.showingResetConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise.circle.fill")
                                        .font(.system(size: 22))
                                    Text("Reset Game Progress")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "bd0e1b"))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "ffbe00"))
                        .font(.system(size: 22))
                }
            )
            .alert("Reset Game?", isPresented: $viewModel.showingResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    viewModel.resetGame()
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("This will reset all your progress, points, and achievements. This action cannot be undone.")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func formatDate(_ date: Date) -> String? {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct SettingToggle: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "ffbe00"))
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(hex: "bd0e1b"))
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(12)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "ffbe00"))
                .frame(width: 30)
            
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

