import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let progress: Int
    let target: Int

    var isUnlocked: Bool {
        progress >= target
    }

    var cappedProgress: Int {
        min(progress, target)
    }

    var progressText: String {
        "\(cappedProgress)/\(target)"
    }
}
