#include <tgmath.h>
#define PHI ((1 + sqrt(5))/2)

long long unsigned fib(unsigned n) {
    return floor( (pow(PHI, n) - pow(1 - PHI, n))/sqrt(5) );
}
