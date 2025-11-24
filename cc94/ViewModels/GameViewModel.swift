//
//  GameViewModel.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var currentPuzzle: Puzzle?
    @Published var userAnswer: String = ""
    @Published var showingResult: Bool = false
    @Published var isCorrect: Bool = false
    @Published var resultMessage: String = ""
    @Published var showingHint: Bool = false
    @Published var currentHints: [String] = []
    @Published var canUnlockMoreHints: Bool = true
    
    private let dataService = DataService.shared
    
    func loadPuzzle(_ puzzle: Puzzle) {
        self.currentPuzzle = puzzle
        self.userAnswer = ""
        self.showingResult = false
        self.isCorrect = false
        self.resultMessage = ""
        self.currentHints = dataService.getUnlockedHints(for: puzzle.id)
        updateHintAvailability()
    }
    
    func submitAnswer() {
        guard let puzzle = currentPuzzle else { return }
        
        let normalizedAnswer = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let normalizedCorrect = puzzle.correctAnswer.lowercased()
        
        if normalizedAnswer == normalizedCorrect {
            isCorrect = true
            resultMessage = "🎉 Correct! You earned \(puzzle.points) points!"
            dataService.completePuzzle(puzzle)
            
            // Haptic feedback
            if dataService.gameSettings.hapticFeedback {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        } else {
            isCorrect = false
            resultMessage = "Not quite right. Try again!"
            
            // Haptic feedback
            if dataService.gameSettings.hapticFeedback {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
        
        showingResult = true
    }
    
    func unlockHint() {
        guard let puzzle = currentPuzzle else { return }
        
        if let newHint = dataService.unlockHint(for: puzzle.id) {
            currentHints.append(newHint)
            showingHint = true
            updateHintAvailability()
            
            // Haptic feedback
            if dataService.gameSettings.hapticFeedback {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
    }
    
    private func updateHintAvailability() {
        guard let puzzle = currentPuzzle else {
            canUnlockMoreHints = false
            return
        }
        
        let unlockedCount = currentHints.count
        canUnlockMoreHints = unlockedCount < puzzle.hints.count && dataService.playerProgress.totalPoints >= 20
    }
    
    func isPuzzleCompleted(_ puzzle: Puzzle) -> Bool {
        return dataService.playerProgress.completedPuzzles.contains(puzzle.id)
    }
    
    func dismissResult() {
        showingResult = false
        if isCorrect {
            currentPuzzle = nil
        }
    }
}

