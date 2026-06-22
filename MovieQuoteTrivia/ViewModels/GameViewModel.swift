import Foundation
import Combine
// MARK: - Supporting Types

struct AnswerOption: Identifiable {
    let id = UUID()
    let movie: String
    let isCorrect: Bool
}

// MARK: - GameViewModel

@MainActor
class GameViewModel: ObservableObject {
    @Published var currentQuestion: Int = 0
    @Published var score: Int = 0
    @Published var currentQuote: Quote?
    @Published var answerOptions: [AnswerOption] = []
    @Published var selectedAnswer: String?
    @Published var answerWasCorrect: Bool?
    @Published var gameFinished: Bool = false

    private var selectedQuotes: [Quote] = []

    // MARK: - Public Properties

    var isGameOver: Bool {
        gameFinished
    }

    var canGoNext: Bool {
        answerWasCorrect != nil && !gameFinished
    }

    var canSubmitAnswer: Bool {
        selectedAnswer != nil && answerWasCorrect == nil && !gameFinished
    }

    // MARK: - Public Methods

    func startNewGame() {
        guard let quotes = QuoteService.shared.getAllQuotes(),
              !quotes.isEmpty,
              QuoteService.shared.hasEnoughUniqueMovies(forOptionCount: 4) else {
            answerOptions = []
            currentQuote = nil
            gameFinished = true
            return
        }

        selectedQuotes = quotes.shuffled().prefix(10).map { $0 }

        currentQuestion = 0
        score = 0
        gameFinished = false
        selectedAnswer = nil
        answerWasCorrect = nil

        loadNextQuestion()
    }

    func selectAnswer(for selectedMovie: String) {
        guard answerWasCorrect == nil, !gameFinished else { return }

        selectedAnswer = selectedMovie
    }

    func submitSelectedAnswer() {
        guard let selectedAnswer,
              answerWasCorrect == nil,
              !gameFinished else { return }

        answerWasCorrect = (selectedAnswer == currentQuote?.movie)

        if answerWasCorrect == true {
            score += 1
        }
    }

    func nextQuestion() {
        guard canGoNext else { return }

        currentQuestion += 1
        selectedAnswer = nil
        answerWasCorrect = nil

        if currentQuestion >= selectedQuotes.count {
            gameFinished = true
        } else {
            loadNextQuestion()
        }
    }

    // MARK: - Private Helpers

    private func loadNextQuestion() {
        guard currentQuestion < selectedQuotes.count else {
            gameFinished = true
            return
        }

        let quote = selectedQuotes[currentQuestion]
        currentQuote = quote

        let wrongMovies = QuoteService.shared.getOtherMovies(excluding: quote, count: 3)

        guard wrongMovies.count == 3 else {
            answerOptions = []
            currentQuote = nil
            gameFinished = true
            return
        }

        var options = wrongMovies.map { AnswerOption(movie: $0, isCorrect: false) }
        options.append(AnswerOption(movie: quote.movie, isCorrect: true))
        answerOptions = options.shuffled()
    }
}
