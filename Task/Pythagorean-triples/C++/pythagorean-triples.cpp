#include <cmath>
#include <iostream>
#include <numeric>
#include <tuple>
#include <vector>

using namespace std;

auto CountTriplets(unsigned long long maxPerimeter)
{
    unsigned long long totalCount = 0;
    unsigned long long primitveCount = 0;
    auto max_M = (unsigned long long)sqrt(maxPerimeter/2) + 1;
    for(unsigned long long m = 2; m < max_M; ++m)
    {
        for(unsigned long long n = 1 + m % 2; n < m; n+=2)
        {
            if(gcd(m,n) != 1)
            {
                continue;
            }

            // The formulas below will generate primitive triples if:
            //   0 < n < m
            //   m and n are relatively prime (gcd == 1)
            //   m + n is odd

            auto a = m * m - n * n;
            auto b = 2 * m * n;
            auto c = m * m + n * n;
            auto perimeter = a + b + c;
            if(perimeter <= maxPerimeter)
            {
                primitveCount++;
                totalCount+= maxPerimeter / perimeter;
            }
        }
    }

    return tuple(totalCount, primitveCount);
}


int main()
{
    vector<unsigned long long> inputs{100, 1000, 10'000, 100'000,
        1000'000, 10'000'000, 100'000'000, 1000'000'000,
        10'000'000'000};  // This last one takes almost a minute
    for(auto maxPerimeter : inputs)
    {
        auto [total, primitive] = CountTriplets(maxPerimeter);
        cout << "\nMax Perimeter: " << maxPerimeter << ", Total: " << total << ", Primitive: " << primitive ;
    }
}
