#include <math.h>
#include <stdio.h>

#define nelems(x) (sizeof(x) / sizeof((x)[0]))

const unsigned long multiplier[] = {1, 3, 5, 7, 11, 3*5, 3*7, 3*11, 5*7, 5*11, 7*11, 3*5*7, 3*5*11, 3*7*11, 5*7*11, 3*5*7*11};

unsigned long long gcd(unsigned long long a, unsigned long long b)
{
    while (b != 0)
    {
        a %= b;
        a ^= b;
        b ^= a;
        a ^= b;
    }

    return a;
}

unsigned long long SQUFOF( unsigned long long N )
{
    unsigned long long D, Po, P, Pprev, Q, Qprev, q, b, r, s;
    unsigned long L, B, i;
    s = (unsigned long long)(sqrtl(N)+0.5);
    if (s*s == N) return s;
    for (int k = 0; k < nelems(multiplier) && N <= 0xffffffffffffffff/multiplier[k]; k++) {
        D = multiplier[k]*N;
        Po = Pprev = P = sqrtl(D);
        Qprev = 1;
        Q = D - Po*Po;
        L = 2 * sqrtl( 2*s );
        B = 3 * L;
        for (i = 2 ; i < B ; i++) {
            b = (unsigned long long)((Po + P)/Q);
            P = b*Q - P;
            q = Q;
            Q = Qprev + b*(Pprev - P);
            r = (unsigned long long)(sqrtl(Q)+0.5);
            if (!(i & 1) && r*r == Q) break;
            Qprev = q;
            Pprev = P;
        };
        if (i >= B) continue;
        b = (unsigned long long)((Po - P)/r);
        Pprev = P = b*r + P;
        Qprev = r;
        Q = (D - Pprev*Pprev)/Qprev;
        i = 0;
        do {
            b = (unsigned long long)((Po + P)/Q);
            Pprev = P;
            P = b*Q - P;
            q = Q;
            Q = Qprev + b*(Pprev - P);
            Qprev = q;
            i++;
        } while (P != Pprev);
        r = gcd(N, Qprev);
        if (r != 1 && r != N) return r;
    }
    return 0;
}

int main(int argc, char *argv[]) {
    int i;
    const unsigned long long data[] = {
        2501,
        12851,
        13289,
        75301,
        120787,
        967009,
        997417,
        7091569,
        13290059,
        42854447,
        223553581,
        2027651281,
        11111111111,
        100895598169,
        1002742628021,
        60012462237239,
        287129523414791,
        9007199254740931,
        11111111111111111,
        314159265358979323,
        384307168202281507,
        419244183493398773,
        658812288346769681,
        922337203685477563,
        1000000000000000127,
        1152921505680588799,
        1537228672809128917,
        4611686018427387877};

    for(int i = 0; i < nelems(data); i++) {
        unsigned long long example, factor, quotient;
        example = data[i];
        factor = SQUFOF(example);
        if(factor == 0) {
            printf("%llu was not factored.\n", example);
        }
        else {
            quotient = example / factor;
            printf("Integer %llu has factors %llu and %llu\n",
               example, factor, quotient);
        }
    }
}
