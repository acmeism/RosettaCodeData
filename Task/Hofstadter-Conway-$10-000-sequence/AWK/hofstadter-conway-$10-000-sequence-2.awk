#!/usr/bin/awk -f
BEGIN {
  Q[1] = 1;
  Q[2] = 1;
  S[1] = 1;
  S[2] = 1;

  NN = 20;
  for (K=1; K<NN; K++) {
    m = 0;
    for (n=2^K+1; n<=2^(K+1); n++) {
        v = HCsequence(n,Q,S)/n;
	if (m < v) {nn=n; m = v};
    }
    printf "Maximum between 2^%i and 2^%i is %f at n=%i\n",K,K+1,m,nn;
  }
}

function HCsequence(n,Q,S) {
  ## recursive definition
  if (S[n]==0) {

  k = n-1;
  if (S[k]==0) {
     HCsequence(k,Q,S);
  }
  k = Q[n-1];
  if (S[k]==0) {
     HCsequence(k,Q,S);
  }
  k = n-Q[n-1];
  if (S[k]==0) {
     HCsequence(k,Q,S);
  }

  }
  Q[n] = Q[Q[n-1]]+Q[n-Q[n-1]];
  S[n] = 1;	
  return (Q[n]);
}
