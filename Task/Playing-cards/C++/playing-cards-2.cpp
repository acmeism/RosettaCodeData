#include <iostream>

int main(int argc, const char** args) {
    cards::deck d;
    d.shuffle();
    std::cout << d;

    return 0;
}
