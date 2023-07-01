#include <iostream>
#include <vector>

int main(int argc, char* argv[])
{
    auto lowers = std::vector<char>({'a', 'b', 'c'});
    auto uppers = std::vector<char>({'A', 'B', 'C'});
    auto nums = std::vector<int>({1, 2, 3});

    auto ilow = lowers.cbegin();
    auto iup = uppers.cbegin();
    auto inum = nums.cbegin();

    for(; ilow != lowers.end()
        and iup != uppers.end()
        and inum != nums.end()
        ; ++ilow, ++iup, ++inum)
    {
       std::cout << *ilow << *iup << *inum << "\n";
    }
}
