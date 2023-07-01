#include <iostream>
using std::cout;
using std::endl;
#include <cmath>
using std::floor;

#include "algorithms.h"
using namespace rosetta::catalanNumbers;


CatalanNumbersDirectFactorial::CatalanNumbersDirectFactorial()
  {
  cout<<"Direct calculation using the factorial"<<endl;
  }

unsigned long long CatalanNumbersDirectFactorial::operator()(unsigned n)const
  {
  if(n>1)
    {
    unsigned long long nFac = factorial(n);
    return factorial(2 * n) / ((n + 1) * nFac * nFac);
    }
  else
    {
    return 1;
    }
  }


CatalanNumbersDirectBinomialCoefficient::CatalanNumbersDirectBinomialCoefficient()
  {
  cout<<"Direct calculation using a binomial coefficient"<<endl;
  }

unsigned long long CatalanNumbersDirectBinomialCoefficient::operator()(unsigned n)const
  {
  if(n>1)
    return double(1) / (n + 1) * binomialCoefficient(2 * n, n);
  else
    return 1;
  }


CatalanNumbersRecursiveSum::CatalanNumbersRecursiveSum()
  {
  cout<<"Recursive calculation using a sum"<<endl;
  }

unsigned long long CatalanNumbersRecursiveSum::operator()(unsigned n)const
  {
  if(n>1)
    {
    const unsigned n_ = n - 1;
    unsigned long long sum = 0;
    for(unsigned i = 0; i <= n_; i++)
      sum += operator()(i) * operator()(n_ - i);
    return sum;
    }
  else
    {
    return 1;
    }
  }


CatalanNumbersRecursiveFraction::CatalanNumbersRecursiveFraction()
  {
  cout<<"Recursive calculation using a fraction"<<endl;
  }

unsigned long long CatalanNumbersRecursiveFraction::operator()(unsigned n)const
  {
  if(n>1)
    return (double(2 * (2 * n - 1)) / (n + 1)) * operator()(n-1);
  else
    return 1;
  }


unsigned long long detail::Factorial::operator()(unsigned n)const
  {
  if(n>1)
    return n * operator()(n-1);
  else
    return 1;
  }


unsigned long long detail::BinomialCoefficient::operator()(unsigned n, unsigned k)const
  {
  if(k == 0)
    return 1;

  if(n == 0)
    return 0;

  double product = 1;
  for(unsigned i = 1; i <= k; i++)
    product *= (double(n - (k - i)) / i);
  return (unsigned long long)(floor(product + 0.5));
  }
