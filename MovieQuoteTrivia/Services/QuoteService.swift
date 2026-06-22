import Foundation

class QuoteService {
    static let shared = QuoteService()

    private var quotes: [Quote] = []

    private init() {
        loadQuotes()
    }

    func loadQuotes() {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json") else {
            print("❌ quotes.json not found in bundle")
            quotes = []
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Quote].self, from: data)
            quotes = decoded
            print("✅ Loaded quotes:", quotes.count)
        } catch {

            print("❌ Failed to load quotes:", error)

            quotes = []

        }

    }

    func getAllQuotes() -> [Quote]? {
        guard !quotes.isEmpty else { return nil }
        return quotes
    }

    func hasEnoughUniqueMovies(forOptionCount count: Int) -> Bool {
        Set(quotes.map { $0.movie }).count >= count
    }

    func getOtherMovies(excluding quote: Quote, count: Int) -> [String] {
        let otherMovies = Set(quotes.map { $0.movie })
            .filter { $0 != quote.movie }

        return Array(otherMovies.shuffled().prefix(count))
    }
}
