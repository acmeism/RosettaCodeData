//SquFoF: minimalistic version without queue.
//Classical heuristic. Tested: tcc 0.9.27
#include <math.h>
#include <stdio.h>

//input maximum
#define MxN ((unsigned long long) 1 << 62)

//reduce indefinite form
#define rho(a, b, c) {        \
  t = c; c = a; a = t; t = b; \
   q = (rN + b) / a;          \
   b = q * a - b;             \
   c += q * (t - b); }

//initialize
#define rhoin(a, b, c) {      \
   rho(a, b, c)  h = b;       \
   c = (mN - h * h) / a; }

#define gcd(a, b) while (b) { \
   t = a % b; a = b; b = t; }

//multipliers
const unsigned long m[] = {1, 3, 5, 7, 11, 0};

//square form factorization
unsigned long squfof( unsigned long long N ) {
unsigned long a, b, c, u, v, w, rN, q, t, r;
unsigned long long mN, h;
int i, ix, k = 0;

   if ((N & 1)==0) return 2;

   h = floor(sqrt(N)+ 0.5);
   if (h * h == N) return h;

   while (m[k]) {
      if (k && N % m[k]==0) return m[k];
      //check overflow m * N
      if (N > MxN / m[k]) break;
      mN = N * m[k++];

      r = floor(sqrt(mN));
      h = r; //float64 fix
      if (h * h > mN) r -= 1;
      rN = r;

      //principal form
      b = r; c = 1;
      rhoin(a, b, c)

      //iteration bound
      ix = floor(sqrt(2*r)) * 4;

      //search principal cycle
      for (i = 2; i < ix; i += 2) {
         rho(a, b, c)
         //even step

         r = floor(sqrt(c)+ 0.5);
         if (r * r == c) {
            //square form found

            //inverse square root
            v = -b; w = r;
            rhoin(u, v, w)

            //search ambiguous cycle
            do { r = v;
              rho(u, v, w)
            } while (v != r);
            //symmetry point

            h = N; gcd(h, u)
            if (h != 1) return h;
         }
         rho(a, b, c)
         //odd step
      }
   }
   return 1;
}

void main(void) {
const unsigned long long data[] = {
   2501,
   12851,
   13289,
   75301,
   120787,
   967009,
   997417,
   7091569,

   5214317,
   20834839,
   23515517,
   33409583,
   44524219,

   13290059,
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
   4611686018427387877,
   0};

   unsigned long long N, f;
   int i = 0;

   while (1) {
      N = data[i++];
      //scanf("%llu", &N);
      if (N < 2) break;

      printf("N = %llu\n", N);

      f = squfof(N);
      if (N % f) f = 1;

      if (f == 1) printf("fail\n\n");
      else printf("f = %llu  N/f = %llu\n\n", f, N/f);
   }
}
