//
//  LevelDetailView.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import SwiftUI

struct LevelDetailView: View {
    let level: Int
    @StateObject private var dataService = DataService.shared
    @State private var selectedPuzzle: Puzzle?
    @Environment(\.presentationMode) var presentationMode
    
    var puzzles: [Puzzle] {
        dataService.getPuzzlesForLevel(level)
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color(hex: "02102b")
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Level header
                            VStack(spacing: 10) {
                                Text("Level \(level)")
                                    .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Choose a puzzle to solve")
                                    .font(.system(size: min(geometry.size.width * 0.04, 16)))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.top, 20)
                            
                            // Puzzles - adaptive grid
                            if geometry.size.width > 700 {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                    ForEach(puzzles) { puzzle in
                                        PuzzleCard(puzzle: puzzle)
                                            .onTapGesture {
                                                selectedPuzzle = puzzle
                                            }
                                    }
                                }
                                .padding()
                            } else {
                                ForEach(puzzles) { puzzle in
                                    PuzzleCard(puzzle: puzzle)
                                        .onTapGesture {
                                            selectedPuzzle = puzzle
                                        }
                                }
                                .padding()
                            }
                        }
                    }
                    }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(hex: "ffbe00"))
                    }
                )
                .sheet(item: $selectedPuzzle) { puzzle in
                    GameView(puzzle: puzzle)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct PuzzleCard: View {
    let puzzle: Puzzle
    @StateObject private var dataService = DataService.shared
    
    var isCompleted: Bool {
        dataService.playerProgress.completedPuzzles.contains(puzzle.id)
    }
    
    var difficultyColor: Color {
        switch puzzle.difficulty {
        case .easy:
            return Color.green
        case .medium:
            return Color(hex: "ffbe00")
        case .hard:
            return Color(hex: "bd0e1b")
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.green : Color(hex: "bd0e1b"))
                    .frame(width: 50, height: 50)
                
                Image(systemName: isCompleted ? "checkmark" : "puzzlepiece.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 5) {
                Text(puzzle.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "ffbe00"))
                        Text("\(puzzle.points) pts")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Circle()
                        .fill(difficultyColor)
                        .frame(width: 8, height: 8)
                    
                    Text(puzzle.difficulty.rawValue.capitalized)
                        .font(.system(size: 14))
                        .foregroundColor(difficultyColor)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color(hex: "ffbe00"))
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCompleted ? Color.green.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
}


