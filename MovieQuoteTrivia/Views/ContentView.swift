import SwiftUI

struct ContentView: View {
    @StateObject private var statsVM = StatsViewModel()
    @State private var showingGame = false
    @State private var showingResults = false
    @State private var showingAchievements = false
    @State private var gameVM = GameViewModel()

    var body: some View {
        NavigationStack {
            HomeView(
                showingGame: $showingGame,
                showingAchievements: $showingAchievements,
                highScore: statsVM.highScore,
                gamesPlayed: statsVM.gamesPlayed,
                totalCorrect: statsVM.totalCorrectAnswers
            )
                .navigationDestination(isPresented: $showingGame) {
                    GameView(gameVM: gameVM, onGameFinished: {
                        statsVM.recordGameResult(score: gameVM.score)
                        showingGame = false
                        showingResults = true
                    })
                }
                .navigationDestination(isPresented: $showingAchievements) {
                    AchievementsView(achievements: statsVM.achievements)
                }
                .navigationDestination(isPresented: $showingResults) {
                    ResultsView(
                        score: gameVM.score,
                        totalQuestions: 10,
                        highScore: statsVM.highScore,
                        gamesPlayed: statsVM.gamesPlayed,
                        totalCorrect: statsVM.totalCorrectAnswers,
                        onPlayAgain: {
                            showingResults = false
                            showingGame = true
                        },
                        onGoHome: {
                            showingResults = false
                        }
                    )
                }
        }
        .onAppear {
            statsVM.loadStats()
        }
    }
}
