//
//  GameView.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import SwiftUI

struct GameView: View {
    let puzzle: Puzzle
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var dataService = DataService.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingHintAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color(hex: "02102b")
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            // Puzzle Header
                            VStack(spacing: 15) {
                                // Pattern visualization
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(hex: "0a1a3b"))
                                        .frame(height: min(geometry.size.height * 0.25, 200))
                                    
                                    VStack(spacing: 10) {
                                        Image(systemName: "puzzlepiece.extension.fill")
                                            .font(.system(size: min(geometry.size.width * 0.15, 60)))
                                            .foregroundColor(Color(hex: "ffbe00"))
                                        
                                        Text(puzzle.imagePattern.replacingOccurrences(of: "pattern_", with: "").capitalized)
                                            .font(.system(size: min(geometry.size.width * 0.04, 16), weight: .medium))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                .padding(.horizontal)
                                
                                Text(puzzle.title)
                                    .font(.system(size: min(geometry.size.width * 0.07, 28), weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(3)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color(hex: "ffbe00"))
                                    Text("\(puzzle.points) points")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, 20)
                        
                            // How to Play Instructions
                            VStack(alignment: .leading, spacing: 15) {
                                HStack(spacing: 8) {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(Color(hex: "ffbe00"))
                                    Text("How to Play")
                                        .font(.system(size: min(geometry.size.width * 0.05, 20), weight: .bold))
                                        .foregroundColor(Color(hex: "ffbe00"))
                                }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                InstructionRow(number: "1", text: "Read the puzzle challenge carefully")
                                InstructionRow(number: "2", text: "Think about the pattern or logic")
                                InstructionRow(number: "3", text: "Enter your answer in the text field")
                                InstructionRow(number: "4", text: "Press Submit to check if you're correct")
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "ffbe00"))
                                    Text("Stuck? Use hints (costs 20 points each)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.8))
                                        .italic()
                                }
                                .padding(.top, 5)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "0a1a3b").opacity(0.5))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                            // Puzzle Description
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Challenge")
                                    .font(.system(size: min(geometry.size.width * 0.05, 20), weight: .bold))
                                    .foregroundColor(Color(hex: "ffbe00"))
                                
                                Text(puzzle.description)
                                    .font(.system(size: min(geometry.size.width * 0.045, 18)))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(hex: "0a1a3b"))
                                    .cornerRadius(12)
                                    .minimumScaleFactor(0.8)
                            }
                            .padding(.horizontal)
                        
                            // Hints Section
                            if !viewModel.currentHints.isEmpty {
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(Color(hex: "ffbe00"))
                                        Text("Hints")
                                            .font(.system(size: min(geometry.size.width * 0.05, 20), weight: .bold))
                                            .foregroundColor(Color(hex: "ffbe00"))
                                    }
                                
                                ForEach(Array(viewModel.currentHints.enumerated()), id: \.offset) { index, hint in
                                    HStack(alignment: .top, spacing: 10) {
                                        Text("\(index + 1).")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color(hex: "ffbe00"))
                                        
                                        Text(hint)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(hex: "0a1a3b").opacity(0.6))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                            // Answer Input
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Your Answer")
                                    .font(.system(size: min(geometry.size.width * 0.05, 20), weight: .bold))
                                    .foregroundColor(.white)
                                
                                TextField("Enter your answer", text: $viewModel.userAnswer)
                                    .font(.system(size: min(geometry.size.width * 0.045, 18)))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(hex: "0a1a3b"))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(hex: "ffbe00"), lineWidth: 2)
                                    )
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            .padding(.horizontal)
                        
                        // Action Buttons
                        VStack(spacing: 15) {
                            Button(action: {
                                viewModel.submitAnswer()
                            }) {
                                Text("Submit Answer")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "bd0e1b"))
                                    .cornerRadius(12)
                            }
                            .disabled(viewModel.userAnswer.isEmpty)
                            .opacity(viewModel.userAnswer.isEmpty ? 0.5 : 1.0)
                            
                            if viewModel.canUnlockMoreHints {
                                Button(action: {
                                    showingHintAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "lightbulb.fill")
                                        Text("Get Hint (20 points)")
                                    }
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "0a1a3b"))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
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
            .onAppear {
                viewModel.loadPuzzle(puzzle)
                }
                .alert(isPresented: $viewModel.showingResult) {
                Alert(
                    title: Text(viewModel.isCorrect ? "Correct!" : "Try Again"),
                    message: Text(viewModel.resultMessage),
                    dismissButton: .default(Text("OK")) {
                        viewModel.dismissResult()
                        if viewModel.isCorrect {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
            .alert("Use Hint?", isPresented: $showingHintAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Use 20 Points") {
                    viewModel.unlockHint()
                }
                } message: {
                    Text("This will cost 20 points. You have \(dataService.playerProgress.totalPoints) points.")
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct InstructionRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color(hex: "ffbe00"))
                    .frame(width: 24, height: 24)
                
                Text(number)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "02102b"))
            }
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
    }
}

