#include <iostream>
#include <iterator>

int main(int argc, char* argv[])
{
    char lowers[] = {'a', 'b', 'c'};
    char uppers[] = {'A', 'B', 'C'};
    int nums[] = {1, 2, 3};

    auto ilow = std::begin(lowers);
    auto iup = std::begin(uppers);
    auto inum = std::begin(nums);

    for(; ilow != std::end(lowers)
        and iup != std::end(uppers)
        and inum != std::end(nums)
        ; ++ilow, ++iup, ++inum )
    {
       std::cout << *ilow << *iup << *inum << "\n";
    }
}
