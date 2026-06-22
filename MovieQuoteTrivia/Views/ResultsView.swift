import SwiftUI

struct ResultsView: View {
    let score: Int
    let totalQuestions: Int
    let highScore: Int
    let gamesPlayed: Int
    let totalCorrect: Int
    let onPlayAgain: () -> Void
    let onGoHome: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("\(score) out of \(totalQuestions)")
                .font(.system(size: 60, weight: .bold))
                .foregroundStyle(.orange)

            if score == highScore && score > 0 {
                Text("New High Score!")
                    .font(.title)
                    .foregroundStyle(.yellow)
            }

            VStack(spacing: 8) {
                Text("Games Played: \(gamesPlayed)")
                Text("Total Correct: \(totalCorrect)")
            }
            .font(.title2)
            .foregroundStyle(.gray)

            Button(action: onPlayAgain) {
                Text("Play Again")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.8))
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            .accessibilityIdentifier("play_again_button")
            .padding(.horizontal)

            Button(action: onGoHome) {
                Text("Home")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            .accessibilityIdentifier("home_button")
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color.black)
    }
}
