#include <iostream>
#include <vector>
#include <numeric>

float sum(const std::vector<float> &array)
{
    return std::accumulate(array.begin(), array.end(), 0.0);
}

float square(float x)
{
    return x * x;
}

float mean(const std::vector<float> &array)
{
    return sum(array) / array.size();
}

float averageSquareDiff(float a, const std::vector<float> &predictions)
{
    std::vector<float> results;
    for (float x : predictions)
        results.push_back(square(x - a));
    return mean(results);
}

void diversityTheorem(float truth, const std::vector<float> &predictions)
{
    float average = mean(predictions);
    std::cout
        << "average-error: " << averageSquareDiff(truth, predictions) << "\n"
        << "crowd-error: " << square(truth - average) << "\n"
        << "diversity: " << averageSquareDiff(average, predictions) << std::endl;
}

int main() {
    diversityTheorem(49, {48,47,51});
    diversityTheorem(49, {48,47,51,42});
    return 0;
}
