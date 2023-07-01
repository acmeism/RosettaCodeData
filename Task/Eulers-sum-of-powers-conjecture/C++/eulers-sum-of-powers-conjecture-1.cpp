#include <algorithm>
#include <iostream>
#include <cmath>
#include <set>
#include <vector>

using namespace std;

bool find()
{
    const auto MAX = 250;
    vector<double> pow5(MAX);
    for (auto i = 1; i < MAX; i++)
        pow5[i] = (double)i * i * i * i * i;
    for (auto x0 = 1; x0 < MAX; x0++) {
        for (auto x1 = 1; x1 < x0; x1++) {
            for (auto x2 = 1; x2 < x1; x2++) {
                for (auto x3 = 1; x3 < x2; x3++) {
                    auto sum = pow5[x0] + pow5[x1] + pow5[x2] + pow5[x3];
                    if (binary_search(pow5.begin(), pow5.end(), sum))
                    {
                        cout << x0 << " " << x1 << " " << x2 << " " << x3 << " " << pow(sum, 1.0 / 5.0) << endl;
                        return true;
                    }
                }
            }
        }
    }
    // not found
    return false;
}

int main(void)
{
    int tm = clock();
    if (!find())
        cout << "Nothing found!\n";
    cout << "time=" << (int)((clock() - tm) * 1000 / CLOCKS_PER_SEC) << " milliseconds\r\n";
    return 0;
}
