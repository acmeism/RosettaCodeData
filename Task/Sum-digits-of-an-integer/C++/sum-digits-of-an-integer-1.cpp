#include <iostream>
#include <cmath>
int SumDigits(const unsigned long long int digits, const int BASE = 10) {
    int sum = 0;
    unsigned long long int x = digits;
    for (int i = log(digits)/log(BASE); i>0; i--){
        const double z = std::pow(BASE,i);
	  const unsigned long long int t = x/z;
	  sum += t;
	  x -= t*z;
    }
    return x+sum;
}

int main() {
        std::cout << SumDigits(1) << ' '
                  << SumDigits(12345) << ' '
                  << SumDigits(123045) << ' '
                  << SumDigits(0xfe, 16) << ' '
                  << SumDigits(0xf0e, 16) << std::endl;
        return 0;
}
