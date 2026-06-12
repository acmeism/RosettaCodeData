#include <iostream>
#include <vector>

int main()
{
    // read the number of lines
    int numberOfLines;
    std::cin >> numberOfLines;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // skip to next line

    // read the lines
    std::vector<std::string> lines(numberOfLines);
    for(int i = 0; i < numberOfLines; ++i)
    {
        std::getline(std::cin, lines[i]);
    }

    // print the lines
    for(const auto& value : lines)
    {
        std::cout << value << "\n";
    }
}
