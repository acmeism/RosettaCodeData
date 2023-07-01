#include <iostream>
#include <gmpxx.h>

static bool is_mersenne_prime(mpz_class p)
{
        if( 2 == p ) {
                return true;
        }

        mpz_class s(4);
        mpz_class div( (mpz_class(1) << p.get_ui()) - 1 );
        for( mpz_class i(3);  i <= p;  ++i )
        {
                s =  (s * s - mpz_class(2)) % div ;
        }

        return ( s == mpz_class(0) );

}
int main()
{
        mpz_class maxcount(45);
        mpz_class found(0);
        mpz_class check(0);
        for( mpz_nextprime(check.get_mpz_t(), check.get_mpz_t());
             found < maxcount;
             mpz_nextprime(check.get_mpz_t(), check.get_mpz_t()))
        {
                //std::cout << "P" << check << " " << std::flush;
                if( is_mersenne_prime(check) )
                {
                        ++found;
                        std::cout << "M" << check << " " << std::flush;
                }
        }
}
