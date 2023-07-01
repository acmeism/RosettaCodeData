// Calculate hypotenuse n of OTT assuming only nothingness, unity, and hyp[n-1] if n>1
// Nigel Galloway, May 6th., 2013
#include <gmpxx.h>
int N{123456};
mpz_class hyp[N-3];
const mpz_class G(const int n,const int g){return g>n?0:(g==1 or n-g<2)?1:hyp[n-g-2];};
void G_hyp(const int n){for(int i=0;i<N-2*n-1;i++) n==1?hyp[n-1+i]=1+G(i+n+1,n+1):hyp[n-1+i]+=G(i+n+1,n+1);}
}
