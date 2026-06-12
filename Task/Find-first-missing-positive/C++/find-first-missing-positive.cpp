#include <iostream>
#include <unordered_set>
#include <vector>

int FindFirstMissing(const std::vector<int>& r)
{
    // put them into an associative container
    std::unordered_set us(r.begin(), r.end());
    size_t result = 0;
    while (us.contains(++result)); // find the first number that isn't there
    return (int)result;
}

int main()
{
    std::vector<std::vector<int>> nums {{1,2,0}, {3,4,-1,1}, {7,8,9,11,12}};
    std::for_each(nums.begin(), nums.end(),
                  [](auto z){std::cout << FindFirstMissing(z) << " "; });
}
