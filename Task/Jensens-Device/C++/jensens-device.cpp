#include <iostream>

#define SUM(i,lo,hi,term)\
[&](const int _lo,const int _hi){\
  decltype(+(term)) sum{};\
  for (i = _lo; i <= _hi; ++i) sum += (term);\
  return sum;\
}((lo),(hi))

int i;
double sum(int &i, int lo, int hi, double (*term)()) {
    double temp = 0;
    for (i = lo; i <= hi; i++)
        temp += term();
    return temp;
}
double term_func() { return 1.0 / i; }

int main () {
    std::cout << sum(i, 1, 100, term_func) << std::endl;
    std::cout << SUM(i,1,100,1.0/i) << "\n";
    return 0;
}
