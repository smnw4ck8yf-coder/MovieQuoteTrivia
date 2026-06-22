import SwiftUI

struct StatisticsView: View {
    let gamesPlayed: Int
    let totalCorrect: Int
    let highScore: Int

    private var totalQuestionsAnswered: Int {
        gamesPlayed * 10
    }

    private var accuracyPercentage: Int {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return Int((Double(totalCorrect) / Double(totalQuestionsAnswered) * 100).rounded())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .accessibilityIdentifier("statistics_title")

                VStack(spacing: 12) {
                    statRow(icon: "gamecontroller.fill", title: "Games Played", value: "\(gamesPlayed)")
                    statRow(icon: "checkmark.circle.fill", title: "Total Correct Answers", value: "\(totalCorrect)")
                    statRow(icon: "star.fill", title: "Highest Score", value: "\(highScore)/10")
                    statRow(icon: "percent", title: "Accuracy", value: "\(accuracyPercentage)%")
                }

                Spacer(minLength: 24)
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier("statistics_screen")
    }

    private func statRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 30)

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)

            Spacer()

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.orange)
        }
        .padding()
        .background(Color.gray.opacity(0.18))
        .cornerRadius(12)
    }
}
