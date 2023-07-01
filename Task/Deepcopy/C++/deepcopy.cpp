#include <array>
#include <iostream>
#include <list>
#include <map>
#include <vector>

int main()
{
    // make a nested structure to copy - a map of arrays containing vectors of strings
    auto myNumbers = std::vector<std::string>{"one", "two", "three", "four"};
    auto myColors = std::vector<std::string>{"red", "green", "blue"};
    auto myArray = std::array<std::vector<std::string>, 2>{myNumbers, myColors};
    auto myMap = std::map<int, decltype(myArray)> {{3, myArray}, {7, myArray}};

    // make a deep copy of the map
    auto mapCopy = myMap;

    // modify the copy
    mapCopy[3][0][1] = "2";
    mapCopy[7][1][2] = "purple";

    std::cout << "the original values:\n";
    std::cout << myMap[3][0][1] << "\n";
    std::cout << myMap[7][1][2] << "\n\n";

    std::cout << "the modified copy:\n";
    std::cout << mapCopy[3][0][1] << "\n";
    std::cout << mapCopy[7][1][2] << "\n";
}
