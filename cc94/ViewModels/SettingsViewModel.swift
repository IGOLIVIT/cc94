//
//  SettingsViewModel.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var hapticFeedback: Bool {
        didSet {
            dataService.gameSettings.hapticFeedback = hapticFeedback
            dataService.saveSettings()
        }
    }
    
    @Published var difficulty: String {
        didSet {
            dataService.gameSettings.difficulty = difficulty
            dataService.saveSettings()
        }
    }
    
    @Published var showingResetConfirmation: Bool = false
    
    private let dataService = DataService.shared
    
    init() {
        self.hapticFeedback = dataService.gameSettings.hapticFeedback
        self.difficulty = dataService.gameSettings.difficulty
    }
    
    func resetGame() {
        dataService.resetGame()
        showingResetConfirmation = false
    }
    
    let difficultyOptions = ["easy", "medium", "hard"]
}

