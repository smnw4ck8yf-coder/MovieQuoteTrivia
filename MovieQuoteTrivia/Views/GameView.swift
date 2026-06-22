import SwiftUI

struct GameView: View {
    @ObservedObject var gameVM: GameViewModel
    let onGameFinished: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Question \(gameVM.currentQuestion + 1) of 10")
                    .font(.caption)
                    .foregroundStyle(.gray)

                Spacer()

                Text("Score: \(gameVM.score)")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))

                    Rectangle()
                        .fill(Color.orange.opacity(0.8))
                        .frame(width: geometry.size.width * Double(gameVM.currentQuestion + 1) / 10.0)
                }
            }
            .frame(height: 4)

            Text(gameVM.currentQuote?.text ?? "NO QUOTE LOADED")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(Array(gameVM.answerOptions.enumerated()), id: \.element.id) { index, option in
                    Button {
                        gameVM.selectAnswer(for: option.movie)
                    } label: {
                        HStack {
                            Text(option.movie)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(answerBackground(for: option))
                        .foregroundStyle(answerForeground(for: option))
                        .cornerRadius(12)
                    }
                    .accessibilityIdentifier("answer_\(index)")
                    .disabled(gameVM.answerWasCorrect != nil)
                }
            }
            .padding(.horizontal)

            if gameVM.answerWasCorrect == nil {
                Button {
                    gameVM.submitSelectedAnswer()

                    if let wasCorrect = gameVM.answerWasCorrect {
                        AnswerFeedbackPlayer.shared.playAnswerFeedback(isCorrect: wasCorrect)
                    }
                } label: {
                    Text("Submit")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(gameVM.canSubmitAnswer ? Color.orange.opacity(0.8) : Color.gray.opacity(0.25))
                        .foregroundStyle(gameVM.canSubmitAnswer ? .white : .gray)
                        .cornerRadius(12)
                }
                .accessibilityIdentifier("submit_button")
                .disabled(!gameVM.canSubmitAnswer)
                .padding(.horizontal)
            }

            if let wasCorrect = gameVM.answerWasCorrect {
                Text(wasCorrect ? "Correct!" : "Wrong! It was \(gameVM.currentQuote?.movie ?? "")")
                    .font(.headline)
                    .foregroundStyle(wasCorrect ? .green : .red)
                    .padding(.horizontal)
            }

            if gameVM.canGoNext {
                Button {
                    gameVM.nextQuestion()

                    if gameVM.gameFinished {
                        onGameFinished()
                    }
                } label: {
                    Text(gameVM.gameFinished ? "See Results" : "Next")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .accessibilityIdentifier("next_button")
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .background(Color.black)
        .onAppear {
            gameVM.startNewGame()
        }
    }

    private func answerBackground(for option: AnswerOption) -> Color {
        if let wasCorrect = gameVM.answerWasCorrect {
            if option.isCorrect {
                return Color.green.opacity(0.3)
            }

            if gameVM.selectedAnswer == option.movie && !wasCorrect {
                return Color.red.opacity(0.3)
            }
        }

        if gameVM.selectedAnswer == option.movie {
            return Color.orange.opacity(0.35)
        }

        return Color.gray.opacity(0.2)
    }

    private func answerForeground(for option: AnswerOption) -> Color {
        if let wasCorrect = gameVM.answerWasCorrect {
            if option.isCorrect {
                return .green
            }

            if gameVM.selectedAnswer == option.movie && !wasCorrect {
                return .red
            }
        }

        if gameVM.selectedAnswer == option.movie {
            return .orange
        }

        return .white
    }
}
