import SwiftUI

struct AchievementsView: View {
    let achievements: [Achievement]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Achievements")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .accessibilityIdentifier("achievements_title")

                ForEach(achievements) { achievement in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 12) {
                            Image(systemName: achievement.isUnlocked ? "checkmark.seal.fill" : "lock.fill")
                                .foregroundStyle(achievement.isUnlocked ? .green : .gray)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(achievement.title)
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                Text(achievement.description)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }

                            Spacer()

                            Text(achievement.progressText)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(achievement.isUnlocked ? .green : .orange)
                        }

                        ProgressView(value: Double(achievement.cappedProgress), total: Double(achievement.target))
                            .tint(achievement.isUnlocked ? .green : .orange)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.18))
                    .cornerRadius(12)
                }

                Spacer(minLength: 24)
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier("achievements_screen")
    }
}
