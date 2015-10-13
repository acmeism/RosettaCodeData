#include <stdio.h>
#include <stdlib.h>

typedef unsigned int uint;

int main(int argc, char **argv)
{
  uint top = atoi(argv[1]);
  uint *divsum = malloc((top + 1) * sizeof(*divsum));
  uint pows[32] = {1, 0};

  for (uint i = 0; i <= top; i++) divsum[i] = 1;

  // sieve
  // only sieve within lower half , the modification starts at 2*p
  for (uint p = 2; p+p <= top; p++) {
    if (divsum[p] > 1) {
      divsum[p] -= p;// subtract number itself from divisor sum ('proper')
      continue;}     // p not prime

    uint x; // highest power of p we need
    //checking x <= top/y instead of x*y <= top to avoid overflow
    for (x = 1; pows[x - 1] <= top/p; x++)
      pows[x] = p*pows[x - 1];

    //counter where n is not a*p with a = ?*p, useful for most p.
    //think of p>31 seldom divisions or p>sqrt(top) than no division is needed
    //n = 2*p, so the prime itself is left unchanged => k=p-1
    uint k= p-1;
    for (uint n = p+p; n <= top; n += p) {
      uint s=1+pows[1];
      k--;
      // search the right power only if needed
      if ( k==0) {
        for (uint i = 2; i < x && !(n%pows[i]); s += pows[i++]);
        k = p; }
      divsum[n] *= s;
    }
  }

  //now correct the upper half
  for (uint p = (top >> 1)+1; p <= top; p++) {
    if (divsum[p] > 1){
      divsum[p] -= p;}
  }

  uint cnt = 0;
  for (uint a = 1; a <= top; a++) {
    uint b = divsum[a];
    if (b > a && b <= top && divsum[b] == a){
      printf("%u %u\n", a, b);
      cnt++;}
  }
  printf("\nTop %u count : %u\n",top,cnt);
  return 0;
}
