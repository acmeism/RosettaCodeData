#!/usr/bin/awk -f
BEGIN {
  NN = 20;
  iterativeHCsequence(2^NN+1,Q);
  for (K=1; K<NN; K++) {
    m = 0;
    for (n=2^K+1; n<=2^(K+1); n++) {
        v = Q[n]/n;
	if (m < v) {nn=n; m = v};
    }
    printf "Maximum a(n)/n between 2^%i and 2^%i is %f at n=%i\n",K,K+1,m,nn;
  }
  print "number of Q(n)<Q(n+1) for n<=100000 : " NN;
}

function iterativeHCsequence(N,Q) {
  Q[1] = 1;
  Q[2] = 1;
  for (n=3; n<=N; n++) {
    Q[n] = Q[Q[n-1]]+Q[n-Q[n-1]];
  }
}
