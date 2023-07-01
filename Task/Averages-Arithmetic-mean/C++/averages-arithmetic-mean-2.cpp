#include <vector>
#include <algorithm>

double mean(const std::vector<double>& numbers)
{
    if (numbers.empty())
        return 0;
    return std::accumulate(numbers.begin(), numbers.end(), 0.0) / numbers.size();
}
