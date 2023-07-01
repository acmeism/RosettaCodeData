#include "algorithms.h"
#include "tester.h"
using namespace rosetta::catalanNumbers;

int main(int argc, char* argv[])
  {
  Test<10, CatalanNumbersDirectFactorial>::Do();
  Test<15, CatalanNumbersDirectBinomialCoefficient>::Do();
  Test<15, CatalanNumbersRecursiveFraction>::Do();
  Test<15, CatalanNumbersRecursiveSum>::Do();
  return 0;
  }
