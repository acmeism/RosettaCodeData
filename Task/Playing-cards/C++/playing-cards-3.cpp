#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

const std::vector<std::string> cards = { "🂡", "🂱", "🃁", "🃑",
                                         "🂢", "🂲", "🃂", "🃒",
                                         "🂣", "🂳", "🃃", "🃓",
                                         "🂤", "🂴", "🃄", "🃔",
                                         "🂥", "🂵", "🃅", "🃕",
                                         "🂦", "🂶", "🃆", "🃖",
                                         "🂧", "🂷", "🃇", "🃗",
                                         "🂨", "🂸", "🂸", "🂸",
                                         "🂩", "🂩", "🃉", "🃙",
                                         "🂪", "🂺", "🃊", "🃚",
                                         "🂫", "🂻", "🃋", "🃛",
                                         "🂭", "🂽", "🃍", "🃝",
                                         "🂮", "🂾", "🃎", "🃞"
};

int main(int argc, const char* args[]) {
    auto deck(cards);
    std::random_shuffle(deck.begin(), deck.end());
    uint i = 1;
    for (auto &card: deck) {
        std::cout << card;
        if (i++ % 13 == 0)
            std::cout << std::endl;
    }

    return 0;
}
