import XCTest

final class MovieQuoteTriviaUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try? super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func staticText(containing text: String) -> XCUIElement {
        app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", text)).firstMatch
    }

    // MARK: - Home screen

    func testHomeScreenExists() throws {
        XCTAssertTrue(app.staticTexts["Movie Quote Trivia"].waitForExistence(timeout: 5),
                      "App should show the home screen")
        XCTAssertTrue(app.buttons["play_button"].exists,
                      "Play button should be present on home screen")
    }

    // MARK: - Start game

    func testTappingPlayShowsFirstQuestion() throws {
        app.buttons["play_button"].tap()
        XCTAssertTrue(staticText(containing: "Question 1 of 10").waitForExistence(timeout: 5),
                      "Should display the first question after tapping Play")
    }

    // MARK: - Full game loop

    func testFullGameLoop() throws {
        // Start game
        app.buttons["play_button"].tap()
        XCTAssertTrue(staticText(containing: "Question 1 of 10").waitForExistence(timeout: 5))

        var score = 0

        for question in 1...10 {
            let qNum = String(question)

            // Verify we are on the expected question
            XCTAssertTrue(staticText(containing: "Question \(qNum) of 10").waitForExistence(timeout: 5),
                          "Should be on question \(question)")

            // Tap the first answer option (any answer; correctness doesn't matter for flow test)
            let answerBtn = app.buttons["answer_0"]
            if answerBtn.exists {
                answerBtn.tap()
            } else {
                // fallback: tap any available button in the answers area
                XCTFail("No 'answer_0' button found on question \(question)")
                continue
            }

            // Submit should appear after selection
            XCTAssertTrue(app.buttons["submit_button"].waitForExistence(timeout: 3),
                          "Submit button should appear after selecting an answer")
            app.buttons["submit_button"].tap()

            // Check result text (correct or wrong)
            if app.staticTexts["Correct!"].waitForExistence(timeout: 2) {
                score += 1
            } else if staticText(containing: "Wrong!").exists {
                // incorrect — score unchanged
            }

            // Next / See Results should appear
            XCTAssertTrue(app.buttons["next_button"].waitForExistence(timeout: 3),
                          "Next/See Results button should appear after submit")

            if question < 10 {
                app.buttons["next_button"].tap()
            } else {
                let nextButton = app.buttons["next_button"]
                print("Final question next_button label: \(nextButton.label)")
                XCTAssertTrue(nextButton.exists,
                              "Final question should show next_button")
                nextButton.tap()

                // Verify results screen
                XCTAssertTrue(app.staticTexts["Game Over"].waitForExistence(timeout: 5),
                              "Should see Game Over on the results screen")
                XCTAssertTrue(staticText(containing: " out of 10").waitForExistence(timeout: 5),
                              "Results should show score in 'X out of 10' format")
                break
            }
        }

        // Log final score (may vary per run because answers are random)
        print("UI test final score: \(score) / 10")
    }

    // MARK: - Play Again

    func testPlayAgainStartsNewGame() throws {
        app.buttons["play_button"].tap()
        XCTAssertTrue(staticText(containing: "Question 1 of 10").waitForExistence(timeout: 5))

        var score = 0
        for question in 1...10 {
            let qNum = String(question)
            XCTAssertTrue(staticText(containing: "Question \(qNum) of 10").waitForExistence(timeout: 5))

            if app.buttons["answer_0"].firstMatch.exists {
                app.buttons["answer_0"].tap()
            }

            XCTAssertTrue(app.buttons["submit_button"].waitForExistence(timeout: 3))
            app.buttons["submit_button"].tap()

            if app.staticTexts["Correct!"].waitForExistence(timeout: 2) {
                score += 1
            }

            XCTAssertTrue(app.buttons["next_button"].waitForExistence(timeout: 3))

            if question < 10 {
                app.buttons["next_button"].tap()
            } else {
                app.buttons["next_button"].tap()
                // Now on results screen — tap Play Again
                XCTAssertTrue(app.buttons["play_again_button"].exists, "Play Again button should be visible")
                app.buttons["play_again_button"].tap()

                // Should see a new question (not necessarily Question 1 because of shuffle)
                XCTAssertTrue(staticText(containing: "Question").waitForExistence(timeout: 5),
                              "Play Again should show another game question")
                break
            }
        }
    }

    // MARK: - Results screen

    func testResultsScreenShowsScore() throws {
        app.buttons["play_button"].tap()
        XCTAssertTrue(staticText(containing: "Question 1 of 10").waitForExistence(timeout: 5))

        var score = 0
        for question in 1...10 {
            let qNum = String(question)
            XCTAssertTrue(staticText(containing: "Question \(qNum) of 10").waitForExistence(timeout: 5))

            if app.buttons["answer_0"].firstMatch.exists {
                app.buttons["answer_0"].tap()
            }

            XCTAssertTrue(app.buttons["submit_button"].waitForExistence(timeout: 3))
            app.buttons["submit_button"].tap()

            if app.staticTexts["Correct!"].waitForExistence(timeout: 2) {
                score += 1
            }

            XCTAssertTrue(app.buttons["next_button"].waitForExistence(timeout: 3))

            if question < 10 {
                app.buttons["next_button"].tap()
            } else {
                app.buttons["next_button"].tap()

                // Verify results screen
                XCTAssertTrue(app.staticTexts["Game Over"].waitForExistence(timeout: 5),
                              "Should see 'Game Over' on the results screen")
                XCTAssertTrue(app.buttons["play_again_button"].exists,
                              "Play Again button should be visible")
                XCTAssertTrue(app.buttons["home_button"].exists,
                              "Home button should be visible")

                // Verify score text (score out of 10)
                let scoreText = staticText(containing: " out of 10")
                XCTAssertTrue(scoreText.waitForExistence(timeout: 3),
                              "Results should show '\(score) out of 10'")

                break
            }
        }

        print("Final score on results screen: \(score)")
    }
}
