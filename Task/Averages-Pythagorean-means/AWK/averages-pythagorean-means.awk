#!/usr/bin/awk -f
{
    x  = $1;   # value of 1st column
    A += x;
    G += log(x);
    H += 1/x;
    N++;	
}

END {
   print "Arithmethic mean: ",A/N;
   print "Geometric mean  : ",exp(G/N);
   print "Harmonic mean   : ",N/H;
}
