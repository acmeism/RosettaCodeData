#include <array>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <string>

int main()
{
    constexpr std::array<const char*, 20> answers = {
        "It is certain.",
        "It is decidedly so.",
        "Without a doubt.",
        "Yes - definitely.",
        "You may rely on it.",
        "As I see it, yes.",
        "Most likely.",
        "Outlook good.",
        "Yes.",
        "Signs point to yes.",
        "Reply hazy, try again.",
        "Ask again later.",
        "Better not tell you now.",
        "Cannot predict now.",
        "Concentrate and ask again.",
        "Don't count on it.",
        "My reply is no.",
        "My sources say no.",
        "Outlook not so good.",
        "Very doubtful."
    };

    std::string input;
    std::srand(std::time(nullptr));
    while (true) {
        std::cout << "\n? : ";
        std::getline(std::cin, input);

        if (input.empty()) {
            break;
        }

        std::cout << answers[std::rand() % answers.size()] << '\n';
    }
}
