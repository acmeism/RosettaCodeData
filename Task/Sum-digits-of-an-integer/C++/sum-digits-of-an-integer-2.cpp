// Template Metaprogramming version by Martin Ettl
#include <iostream>
#include <cmath>

typedef unsigned long long int T;
template <typename T, T i> void For(T &sum, T &x, const T &BASE)
{
    const double z(std::pow(BASE,i));
    const T t = x/z;
    sum += t;
    x -= t*z;
    For<T, i-1>(sum,x,BASE);
}
template <> void For<T,0>(T &, T &, const T &){}

template <typename T, T digits, int BASE> T SumDigits()
 {
    T sum(0);
    T x(digits);
    const T end(log(digits)/log(BASE));
    For<T,end>(sum,x,BASE);
    return x+sum;
}

int main()
{
        std::cout << SumDigits<T, 1     , 10>()  << ' '
                  << SumDigits<T, 12345 , 10>()  << ' '
                  << SumDigits<T, 123045, 10>()  << ' '
                  << SumDigits<T, 0xfe  , 16>()  << ' '
                  << SumDigits<T, 0xf0e , 16>()  << std::endl;
        return 0;
}
