import Foundation
import Combine
// MARK: - StatsViewModel

@MainActor
class StatsViewModel: ObservableObject {
    @Published var highScore: Int = 0
    @Published var gamesPlayed: Int = 0
    @Published var totalCorrectAnswers: Int = 0

    private let highScoreKey = "mqt_highScore"
    private let gamesPlayedKey = "mqt_gamesPlayed"
    private let totalCorrectKey = "mqt_totalCorrectAnswers"

    // MARK: - Public Properties

    var stats: GameStats {
        GameStats(
            highScore: highScore,
            gamesPlayed: gamesPlayed,
            totalCorrectAnswers: totalCorrectAnswers
        )
    }

    var achievements: [Achievement] {
        [
            Achievement(
                id: "first_game_played",
                title: "First Game Played",
                description: "Complete your first game.",
                progress: gamesPlayed,
                target: 1
            ),
            Achievement(
                id: "score_10_out_of_10",
                title: "Score 10/10",
                description: "Get every quote right in one game.",
                progress: min(highScore, 10),
                target: 10
            ),
            Achievement(
                id: "win_5_games",
                title: "Win 5 Games",
                description: "Complete 5 games.",
                progress: gamesPlayed,
                target: 5
            ),
            Achievement(
                id: "answer_50_correctly",
                title: "Answer 50 Questions Correctly",
                description: "Build up 50 correct answers across games.",
                progress: totalCorrectAnswers,
                target: 50
            )
        ]
    }

    // MARK: - Public Methods

    func loadStats() {
        highScore = UserDefaults.standard.integer(forKey: highScoreKey)
        gamesPlayed = UserDefaults.standard.integer(forKey: gamesPlayedKey)
        totalCorrectAnswers = UserDefaults.standard.integer(forKey: totalCorrectKey)
    }

    func recordGameResult(score: Int) {
        gamesPlayed += 1
        totalCorrectAnswers += score

        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: highScoreKey)
        }

        UserDefaults.standard.set(gamesPlayed, forKey: gamesPlayedKey)
        UserDefaults.standard.set(totalCorrectAnswers, forKey: totalCorrectKey)
    }

    func resetStats() {
        highScore = 0
        gamesPlayed = 0
        totalCorrectAnswers = 0

        UserDefaults.standard.set(0, forKey: highScoreKey)
        UserDefaults.standard.set(0, forKey: gamesPlayedKey)
        UserDefaults.standard.set(0, forKey: totalCorrectKey)
    }
}
