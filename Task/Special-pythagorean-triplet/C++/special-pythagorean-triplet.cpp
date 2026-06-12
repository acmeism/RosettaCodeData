#include <cmath>
#include <concepts>
#include <iostream>
#include <numeric>
#include <optional>
#include <tuple>

using namespace std;

optional<tuple<int, int ,int>> FindPerimeterTriplet(int perimeter)
{
    unsigned long long perimeterULL = perimeter;
    auto max_M = (unsigned long long)sqrt(perimeter/2) + 1;
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
            auto primitive = a + b + c;

            // check all multiples of the primitive at once
            auto factor = perimeterULL / primitive;
            if(primitive * factor == perimeterULL)
            {
              // the triplet has been found
              if(b<a) swap(a, b);
              return tuple{a * factor, b * factor, c * factor};
            }
        }
    }

    // the triplet was not found
    return nullopt;
}

int main()
{
  auto t1 = FindPerimeterTriplet(1000);
  if(t1)
  {
    auto [a, b, c] = *t1;
    cout << "[" << a << ", " << b << ", " << c << "]\n";
    cout << "a * b * c = " << a * b * c << "\n";
  }
  else
  {
    cout << "Perimeter not found\n";
  }
}
