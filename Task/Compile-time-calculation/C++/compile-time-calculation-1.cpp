#include <iostream>

template<int i> struct Fac
{
    static const int result = i * Fac<i-1>::result;
};

template<> struct Fac<1>
{
    static const int result = 1;
};


int main()
{
    std::cout << "10! = " << Fac<10>::result << "\n";
    return 0;
}
