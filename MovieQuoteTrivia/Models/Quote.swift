import Foundation

struct Quote: Codable, Identifiable {
    let id: Int
    let text: String
    let movie: String
    let year: Int
    let genre: String
    let difficulty: Int // 1-3
}
