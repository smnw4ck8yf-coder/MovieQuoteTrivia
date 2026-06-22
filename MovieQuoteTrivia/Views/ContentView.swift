import SwiftUI

struct ContentView: View {
    @StateObject private var statsVM = StatsViewModel()
    @State private var showingGame = false
    @State private var showingResults = false
    @State private var showingAchievements = false
    @State private var showingStatistics = false
    @State private var showingSettings = false
    @State private var gameVM = GameViewModel()

    var body: some View {
        NavigationStack {
            HomeView(
                showingGame: $showingGame,
                showingAchievements: $showingAchievements,
                showingStatistics: $showingStatistics,
                showingSettings: $showingSettings,
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
                .navigationDestination(isPresented: $showingStatistics) {
                    StatisticsView(
                        gamesPlayed: statsVM.gamesPlayed,
                        totalCorrect: statsVM.totalCorrectAnswers,
                        highScore: statsVM.highScore
                    )
                }
                .navigationDestination(isPresented: $showingSettings) {
                    SettingsView(onResetStatistics: statsVM.resetStats)
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
