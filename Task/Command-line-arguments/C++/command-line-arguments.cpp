#include <iostream>

int main(int argc, const char* argv[]) {
    std::cout << "This program is named " << argv[0] << '\n'
              << "There are " << argc - 1 << " arguments given.\n";
    for (int i = 1; i < argc; ++i)
        std::cout << "The argument #" << i << " is " << argv[i] << '\n';
}
