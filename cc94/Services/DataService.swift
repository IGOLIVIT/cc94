//
//  DataService.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import Foundation
import SwiftUI
import Combine

class DataService: ObservableObject {
    static let shared = DataService()
    
    private let progressKey = "playerProgress"
    private let settingsKey = "gameSettings"
    
    @Published var playerProgress: PlayerProgress
    @Published var gameSettings: GameSettings
    
    private init() {
        // Load player progress
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode(PlayerProgress.self, from: data) {
            self.playerProgress = decoded
        } else {
            self.playerProgress = PlayerProgress()
        }
        
        // Load game settings
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(GameSettings.self, from: data) {
            self.gameSettings = decoded
        } else {
            self.gameSettings = GameSettings()
        }
    }
    
    func saveProgress() {
        playerProgress.lastPlayedDate = Date()
        if let encoded = try? JSONEncoder().encode(playerProgress) {
            UserDefaults.standard.set(encoded, forKey: progressKey)
        }
    }
    
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(gameSettings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    func completePuzzle(_ puzzle: Puzzle) {
        guard !playerProgress.completedPuzzles.contains(puzzle.id) else { return }
        
        playerProgress.completedPuzzles.append(puzzle.id)
        playerProgress.totalPoints += puzzle.points
        
        // Check for level up
        let currentLevelPuzzles = Puzzle.allPuzzles.filter { 
            getPuzzleLevel($0) == playerProgress.currentLevel 
        }
        let completedInLevel = currentLevelPuzzles.filter { 
            playerProgress.completedPuzzles.contains($0.id) 
        }
        
        if completedInLevel.count == currentLevelPuzzles.count {
            playerProgress.currentLevel += 1
            checkForAchievements()
        }
        
        saveProgress()
    }
    
    func unlockHint(for puzzleId: String) -> String? {
        let puzzle = Puzzle.allPuzzles.first(where: { $0.id == puzzleId })
        guard let puzzle = puzzle else { return nil }
        
        let currentHintIndex = playerProgress.unlockedHints[puzzleId] ?? -1
        let nextHintIndex = currentHintIndex + 1
        
        guard nextHintIndex < puzzle.hints.count else { return nil }
        
        // Cost of hint
        let hintCost = 20
        guard playerProgress.totalPoints >= hintCost else { return nil }
        
        playerProgress.totalPoints -= hintCost
        playerProgress.unlockedHints[puzzleId] = nextHintIndex
        saveProgress()
        
        return puzzle.hints[nextHintIndex]
    }
    
    func getUnlockedHints(for puzzleId: String) -> [String] {
        let puzzle = Puzzle.allPuzzles.first(where: { $0.id == puzzleId })
        guard let puzzle = puzzle else { return [] }
        
        let unlockedIndex = playerProgress.unlockedHints[puzzleId] ?? -1
        guard unlockedIndex >= 0 else { return [] }
        
        return Array(puzzle.hints.prefix(unlockedIndex + 1))
    }
    
    func getPuzzleLevel(_ puzzle: Puzzle) -> Int {
        if let index = Puzzle.allPuzzles.firstIndex(where: { $0.id == puzzle.id }) {
            return (index / 5) + 1
        }
        return 1
    }
    
    func getPuzzlesForLevel(_ level: Int) -> [Puzzle] {
        let startIndex = (level - 1) * 5
        let endIndex = min(startIndex + 5, Puzzle.allPuzzles.count)
        
        guard startIndex < Puzzle.allPuzzles.count else { return [] }
        
        return Array(Puzzle.allPuzzles[startIndex..<endIndex])
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        return level <= playerProgress.currentLevel
    }
    
    func resetGame() {
        playerProgress = PlayerProgress()
        saveProgress()
    }
    
    private func checkForAchievements() {
        // First level completion
        if playerProgress.currentLevel == 2 && !hasAchievement("first_level") {
            let achievement = Achievement(
                id: "first_level",
                title: "First Steps",
                description: "Complete your first level",
                icon: "star.fill",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        // Quarter way there
        if playerProgress.currentLevel == 3 && !hasAchievement("quarter") {
            let achievement = Achievement(
                id: "quarter",
                title: "Getting Started",
                description: "Reach level 3",
                icon: "flame.fill",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        // Half way there
        if playerProgress.currentLevel == 5 && !hasAchievement("halfway") {
            let achievement = Achievement(
                id: "halfway",
                title: "Halfway Hero",
                description: "Reach level 5",
                icon: "bolt.fill",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        // Three quarters
        if playerProgress.currentLevel == 7 && !hasAchievement("three_quarters") {
            let achievement = Achievement(
                id: "three_quarters",
                title: "Almost There",
                description: "Reach level 7",
                icon: "speedometer",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        // Complete all puzzles
        if playerProgress.completedPuzzles.count == Puzzle.allPuzzles.count && !hasAchievement("master") {
            let achievement = Achievement(
                id: "master",
                title: "Puzzle Master",
                description: "Complete all 40 puzzles!",
                icon: "crown.fill",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        // Point milestones
        if playerProgress.totalPoints >= 500 && !hasAchievement("points_500") {
            let achievement = Achievement(
                id: "points_500",
                title: "Point Collector",
                description: "Earn 500 points",
                icon: "star.circle.fill",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        if playerProgress.totalPoints >= 1000 && !hasAchievement("points_1000") {
            let achievement = Achievement(
                id: "points_1000",
                title: "Point Master",
                description: "Earn 1000 points",
                icon: "star.square.fill",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        if playerProgress.totalPoints >= 2000 && !hasAchievement("points_2000") {
            let achievement = Achievement(
                id: "points_2000",
                title: "Point Legend",
                description: "Earn 2000 points",
                icon: "sparkles",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        // Puzzle count milestones
        if playerProgress.completedPuzzles.count >= 10 && !hasAchievement("puzzles_10") {
            let achievement = Achievement(
                id: "puzzles_10",
                title: "Puzzle Solver",
                description: "Complete 10 puzzles",
                icon: "puzzlepiece.fill",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        if playerProgress.completedPuzzles.count >= 20 && !hasAchievement("puzzles_20") {
            let achievement = Achievement(
                id: "puzzles_20",
                title: "Puzzle Expert",
                description: "Complete 20 puzzles",
                icon: "brain.head.profile",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
        
        if playerProgress.completedPuzzles.count >= 30 && !hasAchievement("puzzles_30") {
            let achievement = Achievement(
                id: "puzzles_30",
                title: "Puzzle Champion",
                description: "Complete 30 puzzles",
                icon: "trophy.fill",
                dateEarned: Date()
            )
            playerProgress.achievements.append(achievement)
        }
    }
    
    private func hasAchievement(_ id: String) -> Bool {
        return playerProgress.achievements.contains(where: { $0.id == id })
    }
}

