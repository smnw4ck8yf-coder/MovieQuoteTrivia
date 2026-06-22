import SwiftUI

struct HomeView: View {
    @Binding var showingGame: Bool
    @Binding var showingAchievements: Bool
    let highScore: Int
    let gamesPlayed: Int
    let totalCorrect: Int

    var body: some View {
        VStack(spacing: 32) {
            Text("Movie Quote Trivia")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("Guess the movie from the quote")
                .font(.title2)
                .foregroundStyle(.gray)

            VStack(spacing: 12) {
                Button(action: {
                    showingGame = true
                }) {
                    Text("Play")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .accessibilityIdentifier("play_button")

                Button(action: {
                    showingAchievements = true
                }) {
                    HStack {
                        Image(systemName: "trophy.fill")
                        Text("Achievements")
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .accessibilityIdentifier("achievements_button")
            }

            VStack(spacing: 8) {
                Text("High Score: \(highScore)")
                Text("Games Played: \(gamesPlayed)")
                Text("Total Correct: \(totalCorrect)")
            }
            .font(.caption)
            .foregroundStyle(.gray)

            Spacer()
        }
        .padding()
        .background(Color.black)
        .navigationTitle("")
    }
}
