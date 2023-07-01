#include <valarray>
#include <iostream>

int main()
{
    std::valarray<double> xs = {1,3,-5};
    std::valarray<double> ys = {4,-2,-1};

    double result = (xs * ys).sum();

    std::cout << result << '\n';

    return 0;
}
