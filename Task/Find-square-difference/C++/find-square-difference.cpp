#include <iostream>
#include <ranges>

int main()
{
    const int maxSquareDiff = 1000;
    auto squareCheck = [maxSquareDiff](int i){return 2 * i - 1 > maxSquareDiff;};
    auto answer = std::views::iota(1) |  // {1, 2, 3, 4, 5, ....}
      std::views::filter(squareCheck) |  // filter out the ones that are below 1000
      std::views::take(1);               // take the first one
    std::cout << answer.front() << '\n';
}
