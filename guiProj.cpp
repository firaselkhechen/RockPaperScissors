#include <SFML/Graphics.hpp>
#include <cstdlib>
#include <ctime>
#include <iostream>

enum class Choice {
    ROCK,
    PAPER,
    SCISSORS
};

Choice get_computer_choice() {
    return static_cast<Choice>(rand() % 3);
}

int main() {
    srand(static_cast<unsigned int>(time(nullptr)));

    sf::RenderWindow window(sf::VideoMode(800, 600), "Rock, Paper, Scissors");

    sf::Font font;
    if (!font.loadFromFile("arial.ttf")) {
        return EXIT_FAILURE;
    }

    sf::Text text;
    text.setFont(font);
    text.setCharacterSize(24);
    text.setFillColor(sf::Color::White);
    text.setPosition(50, 300);

    int userScore = 0;
    int compScore = 0;

    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed) {
                window.close();
            }
            else if (event.type == sf::Event::MouseButtonPressed) {
                sf::Vector2i mousePos = sf::Mouse::getPosition(window);
                if (mousePos.y >= 400) {
                    Choice userChoice;
                    if (mousePos.x >= 50 && mousePos.x < 250) {
                        userChoice = Choice::ROCK;
                    }
                    else if (mousePos.x >= 300 && mousePos.x < 500) {
                        userChoice = Choice::PAPER;
                    }
                    else if (mousePos.x >= 550 && mousePos.x < 750) {
                        userChoice = Choice::SCISSORS;
                    }
                    else {
                        continue;  // Invalid choice
                    }

                    Choice compChoice = get_computer_choice();

                    if (userChoice == compChoice) {
                        text.setString("It's a tie!");
                    }
                    else if (
                        (userChoice == Choice::ROCK && compChoice == Choice::SCISSORS) ||
                        (userChoice == Choice::PAPER && compChoice == Choice::ROCK) ||
                        (userChoice == Choice::SCISSORS && compChoice == Choice::PAPER)
                        ) {
                        text.setString("You win this round!");
                        userScore++;
                    }
                    else {
                        text.setString("Computer wins this round!");
                        compScore++;
                    }
                }
            }
        }

        window.clear();

        // Draw the choices
        sf::RectangleShape rockShape(sf::Vector2f(200, 200));
        rockShape.setPosition(50, 400);
        rockShape.setFillColor(sf::Color::Red);
        window.draw(rockShape);

        sf::RectangleShape paperShape(sf::Vector2f(200, 200));
        paperShape.setPosition(300, 400);
        paperShape.setFillColor(sf::Color::Green);
        window.draw(paperShape);

        sf::RectangleShape scissorsShape(sf::Vector2f(200, 200));
        scissorsShape.setPosition(550, 400);
        scissorsShape.setFillColor(sf::Color::Blue);
        window.draw(scissorsShape);

        // Draw the scores
        sf::Text scoreText;
        scoreText.setFont(font);
        scoreText.setCharacterSize(24);
        scoreText.setFillColor(sf::Color::White);
        scoreText.setPosition(50, 50);
        scoreText.setString("Your score: " + std::to_string(userScore));
        window.draw(scoreText);

        scoreText.setPosition(300, 50);
        scoreText.setString("Computer's score: " + std::to_string(compScore));
        window.draw(scoreText);
        window.display();
    }
    return EXIT_SUCCESS;
}