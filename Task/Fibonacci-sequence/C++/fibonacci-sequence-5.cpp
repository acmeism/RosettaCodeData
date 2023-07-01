#include <iostream>

template <int n> struct fibo
{
    enum {value=fibo<n-1>::value+fibo<n-2>::value};
};

template <> struct fibo<0>
{
    enum {value=0};
};

template <> struct fibo<1>
{
    enum {value=1};
};


int main(int argc, char const *argv[])
{
    std::cout<<fibo<12>::value<<std::endl;
    std::cout<<fibo<46>::value<<std::endl;
    return 0;
}
