#!/usr/bin/awk -f
BEGIN {
  N = 100000
  print "Q-sequence(1..10) : " Qsequence(10)
  Qsequence(N,Q)
  print "1000th number of Q sequence : " Q[1000]
  for (n=2; n<=N; n++) {
	if (Q[n]<Q[n-1]) NN++
  }
  print "number of Q(n)<Q(n+1) for n<=100000 : " NN
}

function Qsequence(N,Q) {
  Q[1] = 1
  Q[2] = 1
  seq = "1 1"
  for (n=3; n<=N; n++) {
    Q[n] = Q[n-Q[n-1]]+Q[n-Q[n-2]]
    seq = seq" "Q[n]
  }
  return seq
}
