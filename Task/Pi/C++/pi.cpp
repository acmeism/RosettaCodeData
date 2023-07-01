#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>

using namespace boost::multiprecision;

class Gospers
{
    cpp_int q, r, t, i, n;

public:

    // use Gibbons spigot algorith based on the Gospers series
    Gospers() : q{1}, r{0}, t{1}, i{1}
    {
        ++*this; // move to the first digit
    }

    // the ++ prefix operator will move to the next digit
    Gospers& operator++()
    {
        n = (q*(27*i-12)+5*r) / (5*t);

        while(n != (q*(675*i-216)+125*r)/(125*t))
        {
            r = 3*(3*i+1)*(3*i+2)*((5*i-2)*q+r);
            q = i*(2*i-1)*q;
            t = 3*(3*i+1)*(3*i+2)*t;
            i++;

            n = (q*(27*i-12)+5*r) / (5*t);
        }

        q = 10*q;
        r = 10*r-10*n*t;

        return *this;
    }

    // the dereference operator will give the current digit
    int operator*()
    {
        return (int)n;
    }
};

int main()
{
    Gospers g;

    std::cout << *g << ".";  // print the first digit and the decimal point

    for(;;) // run forever
    {
        std::cout << *++g;  // increment to the next digit and print
    }
}
