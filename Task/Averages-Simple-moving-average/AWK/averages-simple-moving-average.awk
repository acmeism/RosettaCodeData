#!/usr/bin/awk -f
# Moving average over the first column of a data file
BEGIN {
    P = 5;
}

{
    x = $1;	
    i = NR % P;
    MA += (x - Z[i]) / P;
    Z[i] = x;
    print MA;	
}
