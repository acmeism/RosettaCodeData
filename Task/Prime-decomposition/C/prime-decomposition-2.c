#include <limits.h>
#include <stdio.h>
#include <math.h>

typedef enum{false=0, true=1}bool;
const int max_lint = LONG_MAX;

typedef long long int lint;
#assert sizeof_long_long_int (LONG_MAX>=8) /* XXX */

/* the following line is the only time I have ever required "auto" */
#define FOR(i,iterator) auto bool lambda(i); yield_init = (void *)&lambda; iterator; bool lambda(i)
#define DO {
#define     YIELD(x) if(!yield(x))return
#define     BREAK return false
#define     CONTINUE return true
#define OD CONTINUE; }
/* Warning: _Most_ FOR(,){ } loops _must_ have a CONTINUE as the last statement.
 *   Otherwise the lambda will return random value from stack, and may terminate early */

typedef void iterator, lint_iterator; /* hint at procedure purpose */
static volatile void *yield_init; /* not thread safe */
#define YIELDS(type) bool (*yield)(type) = yield_init

typedef unsigned int bits;
#define ELEM(shift, bits) ( (bits >> shift) & 0b1 )

bits cache = 0b0, cached = 0b0;
const lint upb_cache = 8 * sizeof(cache);

lint_iterator decompose(lint); /* forward declaration */

bool is_prime(lint n){
   bool has_factor = false, out = true;
/* for factor in decompose(n) do */
   FOR(lint factor, decompose(n)){
       if( has_factor ){ out = false; BREAK; }
       has_factor = true;
       CONTINUE;
   }
   return out;
}

bool is_prime_cached (lint n){
    lint half_n = n / 2 - 2;
    if( half_n <= upb_cache){
        /* dont cache the initial four, nor the even numbers */
        if (ELEM(half_n,cached)){
            return ELEM(half_n,cache);
        } else {
            bool out = is_prime(n);
            cache = cache | out << half_n;
            cached = cached | 0b1 << half_n;
            return out;
        }
    } else {
        return is_prime(n);
    }
}

lint_iterator primes (){
    YIELDS(lint);
    YIELD(2);
    lint n = 3;
    while( n < max_lint - 2 ){
        YIELD(n);
        n += 2;
        while( n < max_lint - 2 && ! is_prime_cached(n) ){
            n += 2;
        }
    }
}

lint_iterator decompose (lint in_n){
    YIELDS(lint);
    lint n = in_n;
 /* for p in primes do */
    FOR(lint p, primes()){
        if( p*p > n ){
            BREAK;
        } else {
            while( n % p == 0 ){
                YIELD(p);
                n = n / p;
            }
        }
        CONTINUE;
    }
    if( n > 1 ){
        YIELD(n);
    }
}

main(){
    FOR(lint m, primes()){
        lint p = powl(2, m) - 1;
        printf("2**%lld-1 = %lld, with factors:",m,p);
        FOR(lint factor, decompose(p)){
            printf(" %lld",factor);
            fflush(stdout);
            CONTINUE;
        }
        printf("\n",m);
        if( m >= 59 )BREAK;
        CONTINUE;
    }
}
