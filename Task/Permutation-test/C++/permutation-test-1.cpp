#include<iostream>
#include<vector>
#include<numeric>
#include<functional>

class
{
public:
    int64_t operator()(int n, int k){ return partial_factorial(n, k) / factorial(n - k);}
private:
    int64_t partial_factorial(int from, int to) { return from == to ? 1 : from * partial_factorial(from - 1, to); }
    int64_t factorial(int n) { return n == 0 ? 1 : n * factorial(n - 1);}
}combinations;

int main()
{
    static constexpr int treatment = 9;
    const std::vector<int> data{ 85, 88, 75, 66, 25, 29, 83, 39, 97,
                                 68, 41, 10, 49, 16, 65, 32, 92, 28, 98 };

    int treated = std::accumulate(data.begin(), data.begin() + treatment, 0);

    std::function<int (int, int, int)> pick;
    pick = [&](int n, int from, int accumulated)
            {
                if(n == 0)
                    return accumulated > treated ? 1 : 0;
                else
                    return pick(n - 1, from - 1, accumulated + data[from - 1]) +
                            (from > n ? pick(n, from - 1, accumulated) : 0);
            };

    int total   = combinations(data.size(), treatment);
    int greater = pick(treatment, data.size(), 0);
    int lesser  = total - greater;

    std::cout << "<= : " << 100.0 * lesser  / total << "%  " << lesser  << std::endl
              << " > : " << 100.0 * greater / total << "%  " << greater << std::endl;
}
