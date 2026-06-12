#include <array>
#include <cstdio>
#include <numeric>

void PrintContainer(const auto& vec)
{
    int count = 0;
    for(auto value : vec)
    {
        printf("%7d%c", value, ++count % 10 == 0 ? '\n' : ' ');
    }
}

int main()
{
    // define a lambda that cubes a value
    auto cube = [](auto x){return x * x * x;};

    // create an array and use iota to fill it with {0, 1, 2, ... 49}
    std::array<int, 50> a;
    std::iota(a.begin(), a.end(), 0);

    // transform_inclusive_scan will cube all of the values in the array and then
    // perform a partial sum from index 0 to n and place the result back into the
    // array at index n
    std::transform_inclusive_scan(a.begin(), a.end(), a.begin(), std::plus{}, cube);
    PrintContainer(a);
}
