#include <algorithm>
#include <vector>

int main()
{
    std::vector<int> nums;
    nums.push_back(2);
    nums.push_back(4);
    nums.push_back(3);
    nums.push_back(1);
    nums.push_back(2);
    std::sort(nums.begin(), nums.end());
    return 0;
}
