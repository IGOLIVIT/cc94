//
//  OnboardingView.swift
//  PhotoFun Quest
//
//  Created for Session: 7051
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            icon: "puzzlepiece.fill",
            title: "Ready to Challenge Your Mind? 🧠",
            description: "Embark on a journey of mind-bending puzzles and treasure hunt challenges.",
            color: Color(hex: "bd0e1b")
        ),
        OnboardingPage(
            icon: "brain.head.profile",
            title: "Solve Unique Puzzles",
            description: "Test your logic, math, and pattern recognition skills with increasingly challenging puzzles.",
            color: Color(hex: "ffbe00")
        ),
        OnboardingPage(
            icon: "star.fill",
            title: "Earn Points & Achievements",
            description: "Complete puzzles to earn points, unlock new levels, and collect achievements.",
            color: Color(hex: "bd0e1b")
        ),
        OnboardingPage(
            icon: "lightbulb.fill",
            title: "Get Helpful Hints",
            description: "Stuck? Use your points to unlock hints that will guide you to the solution.",
            color: Color(hex: "ffbe00")
        )
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "02102b")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Skip button
                HStack {
                    Spacer()
                    Button(action: {
                        showOnboarding = false
                    }) {
                        Text("Skip")
                            .foregroundColor(Color(hex: "ffbe00"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 500)
                
                Spacer()
                
                // Navigation buttons
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "0a1a3b"))
                                .cornerRadius(12)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            showOnboarding = false
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                            .fontWeight(.semibold)
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
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundColor(page.color)
            
            Text(page.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(page.description)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

