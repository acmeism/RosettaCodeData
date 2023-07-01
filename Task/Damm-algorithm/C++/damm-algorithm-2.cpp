// Compile with:
// g++ -std=c++20 -Wall -Wextra -pedantic damm.cpp -o damm

#include <iostream>
#include <array> // for std::array
#include <string> // for std::string, std::to_string and std::string::find

const std::array<std::array<int, 10>, 10> table = {{ // Operation table
    {0, 3, 1, 7, 5, 9, 8, 6, 4, 2},
    {7, 0, 9, 2, 1, 5, 4, 8, 6, 3},
    {4, 2, 0, 6, 8, 7, 1, 3, 5, 9},
    {1, 7, 5, 0, 9, 8, 3, 4, 2, 6},
    {6, 1, 2, 3, 0, 4, 5, 9, 7, 8},
    {3, 6, 7, 4, 2, 0, 9, 5, 8, 1},
    {5, 8, 6, 9, 7, 2, 0, 1, 3, 4},
    {8, 9, 4, 5, 3, 6, 2, 0, 1, 7},
    {9, 4, 3, 8, 6, 1, 7, 2, 0, 5},
    {2, 5, 8, 1, 4, 3, 6, 7, 9, 0}
}};

bool damm(int input) {
    int interim = 0; // initialise to 0
    const std::string digit = "0123456789";
    for (const auto c : std::to_string(input))
        interim = table[interim][digit.find(c)];
    // Process the number digit by digit:
    //   1. The column index = number's digit
    //   2. The row index = interim digit
    //   3. Replace interim digit with table entry (table[<interim digit>][<number's digit>])
    return interim == 0; // Is interim digit equals zero? If so, the input is valid, invalid otherwise.
}

int main() {
    for (const auto num : {5724, 5727, 112946, 112949})
        std::cout << num << "\t" << "Checksum is " << (damm(num) ? "valid" : "invalid") << std::endl;
    return 0;
}
