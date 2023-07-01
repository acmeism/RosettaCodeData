#include <functional>
#include <iostream>

void PythagoreanTriples(int limit, std::function<void(int,int,int)> yield)
{
    for (int a = 1; a < limit; ++a) {
        for (int b = a+1; b < limit; ++b) {
            for (int c = b+1; c <= limit; ++c) {
                if (a*a + b*b == c*c) {
                    yield(a, b, c);
                }
            }
        }
    }
}

int main()
{
    PythagoreanTriples(20, [](int x, int y, int z)
    {
        std::cout << x << "," << y << "," << z << "\n";
    });
    return 0;
}
