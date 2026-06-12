#include <iostream>
#include <set>
#include <cmath>

int main() {
    std::set<int> values;
    for (int a=2; a<=5; a++)
        for (int b=2; b<=5; b++)
            values.insert(std::pow(a, b));

    for (int i : values)
        std::cout << i << " ";

    std::cout << std::endl;
    return 0;
}
