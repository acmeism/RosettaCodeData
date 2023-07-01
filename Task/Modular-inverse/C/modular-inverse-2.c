#include <stdio.h>

int mul_inv(int a, int b)
{
        int t, nt, r, nr, q, tmp;
        if (b < 0) b = -b;
        if (a < 0) a = b - (-a % b);
        t = 0;  nt = 1;  r = b;  nr = a % b;
        while (nr != 0) {
          q = r/nr;
          tmp = nt;  nt = t - q*nt;  t = tmp;
          tmp = nr;  nr = r - q*nr;  r = tmp;
        }
        if (r > 1) return -1;  /* No inverse */
        if (t < 0) t += b;
        return t;
}
int main(void) {
        printf("%d\n", mul_inv(42, 2017));
        printf("%d\n", mul_inv(40, 1));
        printf("%d\n", mul_inv(52, -217));  /* Pari semantics for negative modulus */
        printf("%d\n", mul_inv(-486, 217));
        printf("%d\n", mul_inv(40, 2018));
        return 0;
}
