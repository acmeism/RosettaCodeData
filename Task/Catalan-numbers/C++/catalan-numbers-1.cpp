#if !defined __ALGORITHMS_H__
#define __ALGORITHMS_H__

namespace rosetta
  {
  namespace catalanNumbers
    {
    namespace detail
      {

      class Factorial
        {
        public:
          unsigned long long operator()(unsigned n)const;
        };

      class BinomialCoefficient
        {
        public:
          unsigned long long operator()(unsigned n, unsigned k)const;
        };

      } //namespace detail

    class CatalanNumbersDirectFactorial
      {
      public:
        CatalanNumbersDirectFactorial();
        unsigned long long operator()(unsigned n)const;
      private:
        detail::Factorial factorial;
      };

    class CatalanNumbersDirectBinomialCoefficient
      {
      public:
        CatalanNumbersDirectBinomialCoefficient();
        unsigned long long operator()(unsigned n)const;
      private:
        detail::BinomialCoefficient binomialCoefficient;
      };

    class CatalanNumbersRecursiveSum
      {
      public:
        CatalanNumbersRecursiveSum();
        unsigned long long operator()(unsigned n)const;
      };

    class CatalanNumbersRecursiveFraction
      {
      public:
        CatalanNumbersRecursiveFraction();
        unsigned long long operator()(unsigned n)const;
      };

    }   //namespace catalanNumbers
  }     //namespace rosetta

#endif //!defined __ALGORITHMS_H__
