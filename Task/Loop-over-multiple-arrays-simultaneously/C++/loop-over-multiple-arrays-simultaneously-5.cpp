#include <iostream>
#include <array>

int main(int argc, char* argv[])
{
    auto lowers = std::array<char, 3>({'a', 'b', 'c'});
    auto uppers = std::array<char, 3>({'A', 'B', 'C'});
    auto nums = std::array<int, 3>({1, 2, 3});

    auto ilow = lowers.cbegin();
    auto iup = uppers.cbegin();
    auto inum = nums.cbegin();

    for(; ilow != lowers.end()
        and iup != uppers.end()
        and inum != nums.end()
        ; ++ilow, ++iup, ++inum )
    {
       std::cout << *ilow << *iup << *inum << "\n";
    }
}
