#include <algorithm>
#include <vector>

int main()
{
    int array[] = { 1,2,3,4,5,6,7,8,9 }; // C-style array of integers
    std::vector<int> vec(array, array + 9); // build STL container from int array

    std::random_shuffle(array, array + 9); // shuffle C-style array
    std::random_shuffle(vec.begin(), vec.end()); // shuffle STL container
}
