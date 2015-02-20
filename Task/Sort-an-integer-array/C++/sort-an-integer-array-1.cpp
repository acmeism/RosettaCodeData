#include <algorithm>

int main()
{
    int nums[] = {2,4,3,1,2};
    std::sort(nums, nums+sizeof(nums)/sizeof(int));
    return 0;
}
