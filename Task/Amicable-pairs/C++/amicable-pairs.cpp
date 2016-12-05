#include <vector>
#include <unordered_map>
#include <iostream>

int main() {
    std::vector<int> alreadyDiscovered;
    std::unordered_map<int, int> divsumMap;
    int count = 0;

    for (int N = 1; N <= 20000; ++N)
    {
        int divSumN = 0;

        for (int i = 1; i <= N / 2; ++i)
        {
            if (fmod(N, i) == 0)
            {
                divSumN += i;
            }
        }

        // populate map of integers to the sum of their proper divisors
        if (divSumN != 1) // do not include primes
            divsumMap[N] = divSumN;

        for (std::unordered_map<int, int>::iterator it = divsumMap.begin(); it != divsumMap.end(); ++it)
        {
            int M = it->first;
            int divSumM = it->second;
            int divSumN = divsumMap[N];

            if (N != M && divSumM == N && divSumN == M)
            {
                // do not print duplicate pairs
                if (std::find(alreadyDiscovered.begin(), alreadyDiscovered.end(), N) != alreadyDiscovered.end())
                    break;

                std::cout << "[" << M << ", " << N << "]" << std::endl;

                alreadyDiscovered.push_back(M);
                alreadyDiscovered.push_back(N);
                count++;
            }
        }
    }

    std::cout << count << " amicable pairs discovered" << std::endl;
}
