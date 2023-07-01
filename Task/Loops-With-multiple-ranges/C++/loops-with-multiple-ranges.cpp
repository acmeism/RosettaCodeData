#include <iostream>
#include <cmath>
#include <vector>

using std::abs;
using std::cout;
using std::pow;
using std::vector;


int main()
{
    int prod  = 1,
        sum   = 0,
        x     = 5,
        y     = -5,
        z     = -2,
        one   = 1,
        three = 3,
        seven = 7;

    auto summingValues = vector<int>{};

    for(int n = -three; n <= pow(3, 3); n += three)
        summingValues.push_back(n);
    for(int n = -seven; n <= seven; n += x)
        summingValues.push_back(n);
    for(int n = 555; n <= 550 - y; ++n)
        summingValues.push_back(n);
    for(int n = 22; n >= -28; n -= three)
        summingValues.push_back(n);
    for(int n = 1927; n <= 1939; ++n)
        summingValues.push_back(n);
    for(int n = x; n >= y; n += z)
        summingValues.push_back(n);
    for(int n = pow(11, x); n <= pow(11, x) + one; ++n)
        summingValues.push_back(n);

    for(auto j : summingValues)
    {
        sum += abs(j);
        if(abs(prod) < pow(2, 27) && j != 0)
            prod *= j;
    }

    cout << "sum = " << sum << "\n";
    cout << "prod = " << prod << "\n";
}
