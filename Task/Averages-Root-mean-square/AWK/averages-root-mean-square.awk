#!/usr/bin/awk -f
# computes RMS of the 1st column of a data file
{
    x  = $1;   # value of 1st column
    S += x*x;
    N++;
}

END {
   print "RMS: ",sqrt(S/N);
}
