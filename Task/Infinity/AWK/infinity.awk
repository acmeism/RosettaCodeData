  BEGIN {
    k=1;
    while (2^(k-1) < 2^k) k++;
    INF = 2^k;
    print INF;
  }
