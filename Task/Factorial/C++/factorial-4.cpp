#include <iostream>
#include <chrono>
#include <vector>
#include <numeric>
#include <algorithm>
#include <boost/iterator/counting_iterator.hpp>

//bad style do-while and wrong for Factorial1(0LL) -> 0 !!!
long long int Factorial1(long long int m_nValue)
{
   long long int result=m_nValue;
   long long int result_next;
   long long int pc = m_nValue;
   do
   {
       result_next = result*(pc-1);
       result = result_next;
       pc--;
   }while(pc>2);
   m_nValue = result;
   return m_nValue;
}

//iteration with while
long long int Factorial2(long long int n)
{
   long long int r = 1;
   while(1<n)
       r *= n--;
   return r;
}

//recrusive
long long int Factorial3(long long int n)
{
   return n<2 ? 1 : n*Factorial3(n-1);
}

//tail recursive
inline long long int _fac_aux(long long int n, long long int acc) {
    return n < 1 ? acc : _fac_aux(n - 1, acc * n);
}
long long int Factorial4(long long int n)
{
   return _fac_aux(n,1);
}

//accumulate with functor
long long int Factorial5(long long int n)
{
  // last is one-past-end
  return std::accumulate(boost::counting_iterator<long long int>(1LL),
                         boost::counting_iterator<long long int>(n+1LL), 1LL,
                         std::multiplies<long long int>() );
}

//accumulate with lamda
long long int Factorial6(long long int n)
{
  // last is one-past-end
  return std::accumulate(boost::counting_iterator<long long int>(1LL),
                         boost::counting_iterator<long long int>(n+1LL), 1LL,
                         [](long long int a, long long int b) { return a*b; } );
}

int main()
{
    int v = 55;
    {
        auto t1 = std::chrono::high_resolution_clock::now();
        auto result = Factorial1(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> ms = t2 - t1;
        std::cout << std::fixed << "do-while(1)              result " << result
                  << " took " << ms.count() << " ms\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        auto result = Factorial2(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> ms = t2 - t1;
        std::cout << std::fixed << "while(2)                 result " << result
                  << " took " << ms.count() << " ms\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        auto result = Factorial3(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> ms = t2 - t1;
        std::cout << std::fixed << "recusive(3)              result " << result
                  << " took " << ms.count() << " ms\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        auto result = Factorial3(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> ms = t2 - t1;
        std::cout << std::fixed << "tail recusive(4)         result " << result
                  << " took " << ms.count() << " ms\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        auto result = Factorial5(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> ms = t2 - t1;
        std::cout << std::fixed << "std::accumulate(5)       result " << result
                  << " took " << ms.count() << " ms\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        auto result = Factorial6(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> ms = t2 - t1;
        std::cout << std::fixed << "std::accumulate lamda(6) result " << result
                  << " took " << ms.count() << " ms\n";
    }
}
