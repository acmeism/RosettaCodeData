#include <list>

int main()
{
    std::list<int> nums;
    nums.push_back(2);
    nums.push_back(4);
    nums.push_back(3);
    nums.push_back(1);
    nums.push_back(2);
    nums.sort();
    return 0;
}
