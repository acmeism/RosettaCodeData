#include <iostream>
#include <gmpxx.h>

int main()
{
        mpz_class a = mpz_class(1), b = mpz_class(1);
        mpz_class target = mpz_class(100);
        for(mpz_class n = mpz_class(3); n <= target; ++n)
        {
                mpz_class fib = b + a;
                if ( fib < b )
                {
                        std::cout << "Overflow at " << n << std::endl;
                        break;
                }
                std::cout << "F("<< n << ") = " << fib << std::endl;
                a = b;
                b = fib;
        }
        return 0;
}
