#include <iostream>
#include <array>
#include <algorithm>

int main(int argc, char* argv[])
{
    auto lowers = std::array<char, 3>({'a', 'b', 'c'});
    auto uppers = std::array<char, 3>({'A', 'B', 'C'});
    auto nums = std::array<int, 3>({1, 2, 3});

    auto const minsize = std::min(
                lowers.size(),
                std::min(
                    uppers.size(),
                    nums.size()
                    )
                );

    for(size_t i = 0; i < minsize; ++i)
    {
       std::cout << lowers[i] << uppers[i] << nums[i] << "\n";
    }
}
