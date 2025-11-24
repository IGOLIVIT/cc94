//
//  GameModel.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import Foundation
import SwiftUI

// MARK: - Game Models

struct Puzzle: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let imagePattern: String // Pattern description for the puzzle
    let correctAnswer: String
    let hints: [String]
    let difficulty: Difficulty
    let points: Int
    
    enum Difficulty: String, Codable {
        case easy
        case medium
        case hard
    }
}

struct PlayerProgress: Codable {
    var currentLevel: Int
    var totalPoints: Int
    var completedPuzzles: [String]
    var unlockedHints: [String: Int] // puzzleId: hintIndex
    var achievements: [Achievement]
    var lastPlayedDate: Date
    
    init() {
        self.currentLevel = 1
        self.totalPoints = 0
        self.completedPuzzles = []
        self.unlockedHints = [:]
        self.achievements = []
        self.lastPlayedDate = Date()
    }
}

struct Achievement: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let dateEarned: Date
}

struct GameSettings: Codable {
    var hapticFeedback: Bool
    var difficulty: String
    
    init() {
        self.hapticFeedback = true
        self.difficulty = "medium"
    }
}

// MARK: - Puzzle Data

extension Puzzle {
    static let allPuzzles: [Puzzle] = [
        // LEVEL 1 - Easy Puzzles (Warm-up)
        Puzzle(
            id: "puzzle_1",
            title: "The Hidden Number",
            description: "Find the missing number in the pattern: 2, 4, 8, ?, 32",
            imagePattern: "pattern_numbers",
            correctAnswer: "16",
            hints: [
                "Look at how each number relates to the previous one",
                "Try multiplying by 2",
                "Each number is double the previous number"
            ],
            difficulty: .easy,
            points: 100
        ),
        Puzzle(
            id: "puzzle_2",
            title: "Color Code Mystery",
            description: "If RED = 3 letters, BLUE = 4 letters, what does GREEN equal?",
            imagePattern: "pattern_colors",
            correctAnswer: "5",
            hints: [
                "Count the letters in the word",
                "It's about the length of the word",
                "GREEN has 5 letters"
            ],
            difficulty: .easy,
            points: 100
        ),
        Puzzle(
            id: "puzzle_3",
            title: "Shape Shifter",
            description: "Circle, Square, Triangle, Circle, Square, ?",
            imagePattern: "pattern_shapes",
            correctAnswer: "triangle",
            hints: [
                "Look for a repeating pattern",
                "The pattern repeats every 3 shapes",
                "It follows the sequence: Circle, Square, Triangle"
            ],
            difficulty: .easy,
            points: 100
        ),
        Puzzle(
            id: "puzzle_4",
            title: "Simple Sum",
            description: "What is 15 + 27?",
            imagePattern: "pattern_math",
            correctAnswer: "42",
            hints: [
                "Just add the two numbers together",
                "15 + 27",
                "The answer is 42"
            ],
            difficulty: .easy,
            points: 100
        ),
        Puzzle(
            id: "puzzle_5",
            title: "Days of the Week",
            description: "If today is Monday, what day will it be in 3 days?",
            imagePattern: "pattern_calendar",
            correctAnswer: "thursday",
            hints: [
                "Count forward from Monday",
                "Mon → Tue → Wed → Thu",
                "It will be Thursday"
            ],
            difficulty: .easy,
            points: 100
        ),
        
        // LEVEL 2 - Medium Puzzles (Getting Challenging)
        Puzzle(
            id: "puzzle_6",
            title: "The Time Traveler",
            description: "If 2 hours ago it was 3 PM, what time will it be in 3 hours?",
            imagePattern: "pattern_clock",
            correctAnswer: "8",
            hints: [
                "First figure out what time it is now",
                "If 2 hours ago was 3 PM, now is 5 PM",
                "Add 3 hours to 5 PM = 8 PM"
            ],
            difficulty: .medium,
            points: 150
        ),
        Puzzle(
            id: "puzzle_7",
            title: "Letter Logic",
            description: "A = 1, B = 2, C = 3... What number is the word CAT?",
            imagePattern: "pattern_letters",
            correctAnswer: "24",
            hints: [
                "Add up the values of each letter",
                "C=3, A=1, T=20",
                "3 + 1 + 20 = 24"
            ],
            difficulty: .medium,
            points: 150
        ),
        Puzzle(
            id: "puzzle_8",
            title: "The Missing Piece",
            description: "3, 5, 9, 17, 33, ?",
            imagePattern: "pattern_sequence",
            correctAnswer: "65",
            hints: [
                "Look at how much is added each time",
                "The differences are: 2, 4, 8, 16...",
                "Each difference doubles: add 32 to 33"
            ],
            difficulty: .medium,
            points: 150
        ),
        Puzzle(
            id: "puzzle_9",
            title: "Price Calculator",
            description: "A book costs $12 and you buy 3 books with a 10% discount. How much do you pay? (whole number)",
            imagePattern: "pattern_money",
            correctAnswer: "32",
            hints: [
                "First calculate total: 12 × 3 = 36",
                "Then calculate 10% of 36 = 3.6",
                "36 - 3.6 = 32.4, rounded to 32"
            ],
            difficulty: .medium,
            points: 150
        ),
        Puzzle(
            id: "puzzle_10",
            title: "Word Pattern",
            description: "BAT, CAT, HAT, MAT, ?AT (3-letter word)",
            imagePattern: "pattern_words",
            correctAnswer: "pat",
            hints: [
                "Look at the first letter of each word",
                "B, C, H, M... which letter comes next alphabetically after M?",
                "The answer is PAT (P comes after M skipping some letters, but fits the rhyme)"
            ],
            difficulty: .medium,
            points: 150
        ),
        
        // LEVEL 3 - Harder Puzzles
        Puzzle(
            id: "puzzle_11",
            title: "The Treasure Code",
            description: "If MOON = 4332 and SOON = 5332, what is NOON?",
            imagePattern: "pattern_cipher",
            correctAnswer: "3332",
            hints: [
                "Each letter has a specific number",
                "M=4, O=3, S=5, N=2",
                "NOON = 3332 (N-O-O-N)"
            ],
            difficulty: .hard,
            points: 200
        ),
        Puzzle(
            id: "puzzle_12",
            title: "Age Puzzle",
            description: "A father is 4 times as old as his son. In 20 years, he'll be twice as old. How old is the son now?",
            imagePattern: "pattern_age",
            correctAnswer: "10",
            hints: [
                "Set up an equation with the son's age as x",
                "Father is 4x now, son is x",
                "In 20 years: 4x + 20 = 2(x + 20)",
                "Solve: 4x + 20 = 2x + 40, so 2x = 20, x = 10"
            ],
            difficulty: .hard,
            points: 200
        ),
        Puzzle(
            id: "puzzle_13",
            title: "The Secret Path",
            description: "Following the pattern: 1, 1, 2, 3, 5, 8, ?, 21",
            imagePattern: "pattern_fibonacci",
            correctAnswer: "13",
            hints: [
                "Each number is related to the previous two",
                "Try adding the previous two numbers together",
                "This is the Fibonacci sequence: 5 + 8 = 13"
            ],
            difficulty: .hard,
            points: 200
        ),
        Puzzle(
            id: "puzzle_14",
            title: "Square Numbers",
            description: "What is the next number? 1, 4, 9, 16, 25, ?",
            imagePattern: "pattern_squares",
            correctAnswer: "36",
            hints: [
                "These are perfect squares: 1², 2², 3²...",
                "The pattern is 1×1, 2×2, 3×3, 4×4, 5×5",
                "Next is 6×6 = 36"
            ],
            difficulty: .hard,
            points: 200
        ),
        Puzzle(
            id: "puzzle_15",
            title: "Reverse Logic",
            description: "If you read STRESSED backwards, what word do you get?",
            imagePattern: "pattern_reverse",
            correctAnswer: "desserts",
            hints: [
                "Write the word backwards letter by letter",
                "S-T-R-E-S-S-E-D becomes D-E-S-S-E-R-T-S",
                "The answer is DESSERTS"
            ],
            difficulty: .hard,
            points: 200
        ),
        
        // LEVEL 4 - Expert Puzzles
        Puzzle(
            id: "puzzle_16",
            title: "Logic Chain",
            description: "If all Bloops are Razzies and all Razzies are Lazzies, are all Bloops Lazzies?",
            imagePattern: "pattern_logic",
            correctAnswer: "yes",
            hints: [
                "This is a logic chain problem",
                "If A→B and B→C, then A→C",
                "Bloops→Razzies→Lazzies, so Bloops→Lazzies"
            ],
            difficulty: .hard,
            points: 250
        ),
        Puzzle(
            id: "puzzle_17",
            title: "Prime Mystery",
            description: "What is the 7th prime number?",
            imagePattern: "pattern_primes",
            correctAnswer: "17",
            hints: [
                "Prime numbers: 2, 3, 5, 7, 11, 13, ?",
                "Count to the 7th one",
                "The 7th prime is 17"
            ],
            difficulty: .hard,
            points: 250
        ),
        Puzzle(
            id: "puzzle_18",
            title: "Triangle Numbers",
            description: "1, 3, 6, 10, 15, ?",
            imagePattern: "pattern_triangle",
            correctAnswer: "21",
            hints: [
                "Add 2, then 3, then 4, then 5...",
                "The differences increase by 1 each time",
                "15 + 6 = 21"
            ],
            difficulty: .hard,
            points: 250
        ),
        Puzzle(
            id: "puzzle_19",
            title: "Roman Riddle",
            description: "What is XIV + IX in Roman numerals? (answer in number)",
            imagePattern: "pattern_roman",
            correctAnswer: "23",
            hints: [
                "XIV = 14, IX = 9",
                "Add them together: 14 + 9",
                "The answer is 23"
            ],
            difficulty: .hard,
            points: 250
        ),
        Puzzle(
            id: "puzzle_20",
            title: "Binary Code",
            description: "What is 1010 in binary as a decimal number?",
            imagePattern: "pattern_binary",
            correctAnswer: "10",
            hints: [
                "Binary: 1×8 + 0×4 + 1×2 + 0×1",
                "8 + 0 + 2 + 0",
                "The answer is 10"
            ],
            difficulty: .hard,
            points: 250
        ),
        
        // LEVEL 5 - Master Puzzles
        Puzzle(
            id: "puzzle_21",
            title: "Egg Timer",
            description: "You have a 7-minute and 11-minute hourglass. How do you measure exactly 15 minutes?",
            imagePattern: "pattern_timer",
            correctAnswer: "11",
            hints: [
                "Start both hourglasses at the same time",
                "When 7-min runs out, 4 minutes remain on 11-min",
                "Flip the 7-min. When 11-min ends, flip 7-min again (4 min left). That's 11+4 = 15 min. Answer: 11"
            ],
            difficulty: .hard,
            points: 300
        ),
        Puzzle(
            id: "puzzle_22",
            title: "Cube Numbers",
            description: "What comes next? 1, 8, 27, 64, ?",
            imagePattern: "pattern_cubes",
            correctAnswer: "125",
            hints: [
                "These are cubes: 1³, 2³, 3³, 4³",
                "1×1×1, 2×2×2, 3×3×3, 4×4×4",
                "Next is 5³ = 5×5×5 = 125"
            ],
            difficulty: .hard,
            points: 300
        ),
        Puzzle(
            id: "puzzle_23",
            title: "Speed Math",
            description: "If a train travels 120 km in 2 hours, how many km in 5 hours at the same speed?",
            imagePattern: "pattern_speed",
            correctAnswer: "300",
            hints: [
                "First find the speed: 120 ÷ 2 = 60 km/h",
                "Then multiply by 5 hours",
                "60 × 5 = 300 km"
            ],
            difficulty: .hard,
            points: 300
        ),
        Puzzle(
            id: "puzzle_24",
            title: "Percentage Puzzle",
            description: "What is 25% of 80?",
            imagePattern: "pattern_percent",
            correctAnswer: "20",
            hints: [
                "25% means 25 out of 100, or 1/4",
                "Calculate 80 ÷ 4",
                "The answer is 20"
            ],
            difficulty: .hard,
            points: 300
        ),
        Puzzle(
            id: "puzzle_25",
            title: "Divisibility Test",
            description: "How many numbers between 1 and 20 are divisible by 3?",
            imagePattern: "pattern_division",
            correctAnswer: "6",
            hints: [
                "List them: 3, 6, 9, 12, 15, 18",
                "Count how many numbers",
                "There are 6 numbers"
            ],
            difficulty: .hard,
            points: 300
        ),
        
        // LEVEL 6 - Advanced Puzzles
        Puzzle(
            id: "puzzle_26",
            title: "Coin Puzzle",
            description: "You have 3 coins. One is counterfeit and lighter. With one weighing on a balance, how do you find it? Answer: number of coins on each side.",
            imagePattern: "pattern_coins",
            correctAnswer: "1",
            hints: [
                "Put 1 coin on each side of the balance",
                "If balanced, the third coin is fake",
                "If not balanced, the lighter side has the fake. Answer: 1"
            ],
            difficulty: .hard,
            points: 350
        ),
        Puzzle(
            id: "puzzle_27",
            title: "Mirror Numbers",
            description: "If 12 flipped upside down is 21, what number looks the same upside down? (2 digits)",
            imagePattern: "pattern_mirror",
            correctAnswer: "69",
            hints: [
                "Numbers that flip: 0, 1, 6, 8, 9",
                "6 upside down is 9, 9 upside down is 6",
                "69 upside down is 69"
            ],
            difficulty: .hard,
            points: 350
        ),
        Puzzle(
            id: "puzzle_28",
            title: "Power of Two",
            description: "What is 2 to the power of 6? (2⁶)",
            imagePattern: "pattern_powers",
            correctAnswer: "64",
            hints: [
                "Multiply: 2 × 2 × 2 × 2 × 2 × 2",
                "Or: 2, 4, 8, 16, 32, 64",
                "The answer is 64"
            ],
            difficulty: .hard,
            points: 350
        ),
        Puzzle(
            id: "puzzle_29",
            title: "Average Speed",
            description: "If you drive 60 km/h for 1 hour, then 80 km/h for 1 hour, what's your average speed?",
            imagePattern: "pattern_average",
            correctAnswer: "70",
            hints: [
                "Total distance: 60 + 80 = 140 km",
                "Total time: 1 + 1 = 2 hours",
                "Average: 140 ÷ 2 = 70 km/h"
            ],
            difficulty: .hard,
            points: 350
        ),
        Puzzle(
            id: "puzzle_30",
            title: "Factorial Fun",
            description: "What is 5! (5 factorial)?",
            imagePattern: "pattern_factorial",
            correctAnswer: "120",
            hints: [
                "5! means 5 × 4 × 3 × 2 × 1",
                "Calculate step by step: 5×4=20, 20×3=60, 60×2=120",
                "The answer is 120"
            ],
            difficulty: .hard,
            points: 350
        ),
        
        // LEVEL 7 - Expert Master Puzzles
        Puzzle(
            id: "puzzle_31",
            title: "Calendar Math",
            description: "If January 1st, 2024 is a Monday, what day is January 8th, 2024?",
            imagePattern: "pattern_date",
            correctAnswer: "monday",
            hints: [
                "Count 7 days from Monday",
                "7 days = 1 week",
                "Same day: Monday"
            ],
            difficulty: .hard,
            points: 400
        ),
        Puzzle(
            id: "puzzle_32",
            title: "Circular Logic",
            description: "A circle has 360 degrees. How many degrees in 1/4 of a circle?",
            imagePattern: "pattern_geometry",
            correctAnswer: "90",
            hints: [
                "1/4 means divide by 4",
                "360 ÷ 4",
                "The answer is 90 degrees"
            ],
            difficulty: .hard,
            points: 400
        ),
        Puzzle(
            id: "puzzle_33",
            title: "Pattern Master",
            description: "2, 6, 12, 20, 30, ?",
            imagePattern: "pattern_complex",
            correctAnswer: "42",
            hints: [
                "Look at differences: +4, +6, +8, +10",
                "Next difference is +12",
                "30 + 12 = 42"
            ],
            difficulty: .hard,
            points: 400
        ),
        Puzzle(
            id: "puzzle_34",
            title: "Hexadecimal",
            description: "What is F in hexadecimal as a decimal number?",
            imagePattern: "pattern_hex",
            correctAnswer: "15",
            hints: [
                "Hex: 0-9 then A-F",
                "A=10, B=11, C=12, D=13, E=14, F=?",
                "F = 15"
            ],
            difficulty: .hard,
            points: 400
        ),
        Puzzle(
            id: "puzzle_35",
            title: "Word Value Max",
            description: "Using A=1, B=2... Z=26, which has higher value: ACE or BED?",
            imagePattern: "pattern_wordvalue",
            correctAnswer: "bed",
            hints: [
                "ACE = 1+3+5 = 9",
                "BED = 2+5+4 = 11",
                "BED has higher value"
            ],
            difficulty: .hard,
            points: 400
        ),
        
        // LEVEL 8 - Ultimate Challenge
        Puzzle(
            id: "puzzle_36",
            title: "Time Zone",
            description: "If it's 3 PM in New York (EST) and London is 5 hours ahead, what time is it in London? (24-hour format)",
            imagePattern: "pattern_timezone",
            correctAnswer: "20",
            hints: [
                "3 PM = 15:00 in 24-hour format",
                "Add 5 hours: 15 + 5",
                "20:00 (8 PM). Answer: 20"
            ],
            difficulty: .hard,
            points: 500
        ),
        Puzzle(
            id: "puzzle_37",
            title: "Pythagorean Triple",
            description: "In a right triangle with sides 3 and 4, what is the hypotenuse?",
            imagePattern: "pattern_pythagoras",
            correctAnswer: "5",
            hints: [
                "Use Pythagorean theorem: a² + b² = c²",
                "3² + 4² = 9 + 16 = 25",
                "√25 = 5"
            ],
            difficulty: .hard,
            points: 500
        ),
        Puzzle(
            id: "puzzle_38",
            title: "Logic Gates",
            description: "If A=1 and B=0, what is A AND B? (in binary)",
            imagePattern: "pattern_logic_gates",
            correctAnswer: "0",
            hints: [
                "AND gate: both must be 1 for output to be 1",
                "1 AND 0 = ?",
                "The answer is 0"
            ],
            difficulty: .hard,
            points: 500
        ),
        Puzzle(
            id: "puzzle_39",
            title: "Compound Interest",
            description: "You invest $100 at 10% per year. After 2 years, how much? (round to nearest dollar)",
            imagePattern: "pattern_interest",
            correctAnswer: "121",
            hints: [
                "Year 1: 100 + 10% = 110",
                "Year 2: 110 + 10% = 121",
                "Compound interest: $121"
            ],
            difficulty: .hard,
            points: 500
        ),
        Puzzle(
            id: "puzzle_40",
            title: "Ultimate Pattern",
            description: "1, 4, 9, 16, 25, 36, 49, 64, 81, ?",
            imagePattern: "pattern_ultimate",
            correctAnswer: "100",
            hints: [
                "These are perfect squares: 1², 2², 3²...",
                "The 10th square",
                "10² = 100"
            ],
            difficulty: .hard,
            points: 500
        )
    ]
}

