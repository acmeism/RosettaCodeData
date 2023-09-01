// Written by Katsumi -- twitter.com/realKatsumi_vn
// Compile with: g++ -std=c++20 -Wall -Wextra -pedantic NumberReversal.cpp -o NumberReversal
#include <iostream>
#include <algorithm>
#include <utility>
#include <functional>
#include <iterator>
#include <random>
#include <vector>
#include <string>

template <class T>
bool Sorted(std::vector<T> list) {
    return std::adjacent_find(list.begin(), list.end(), std::greater<T>()) == list.end();
}

template <class T>
std::string VectorRepr(std::vector<T> list) {
    auto Separate = [](std::string a, int b) {
        return std::move(a) + ", " + std::to_string(b);
    };
    return std::accumulate(std::next(list.begin()), list.end(), std::to_string(list[0]), Separate);
}

int main() {
    const std::string IntroText = "NUMBER REVERSAL GAME\n"
                                  "based on a \"task\" on Rosetta Code -- rosettacode.org\n"
                                  "by Katsumi -- twitter.com/realKatsumi.vn\n\n";

    // Don't ever write this s**tty code...
    // std::srand(std::time(0));
    // Do this instead:
    std::random_device Device;
    std::mt19937_64 Generator(Device());

    std::vector<int> List = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    std::shuffle(List.begin(), List.end(), Generator);

    std::cout << IntroText;

    int Moves, PlayerInput;
    while (!Sorted(List)) {
        std::cout << "Current list: [" << VectorRepr(List) << "]\n"
                     "Digits to reverse? (2-9) ";
        while (true) {
            std::cin >> PlayerInput;
            if (PlayerInput < 2 || PlayerInput > 9)
                std::cout << "Please enter a value between 2 and 9.\n"
                             "Digits to reverse? (2-9) ";
            else
                break;
        }

        std::reverse(List.begin(), List.begin()+PlayerInput);
        ++Moves;
    }

    std::cout << "Yay! You sorted the list! You've made " << Moves << " moves.\n";

    return 0;
}
