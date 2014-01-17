# syntax: GAWK -f CLOSEST-PAIR_PROBLEM.AWK
BEGIN {
    x[++n] = 0.654682 ; y[n] = 0.925557
    x[++n] = 0.409382 ; y[n] = 0.619391
    x[++n] = 0.891663 ; y[n] = 0.888594
    x[++n] = 0.716629 ; y[n] = 0.996200
    x[++n] = 0.477721 ; y[n] = 0.946355
    x[++n] = 0.925092 ; y[n] = 0.818220
    x[++n] = 0.624291 ; y[n] = 0.142924
    x[++n] = 0.211332 ; y[n] = 0.221507
    x[++n] = 0.293786 ; y[n] = 0.691701
    x[++n] = 0.839186 ; y[n] = 0.728260
    min = 1E20
    for (i=1; i<=n-1; i++) {
      for (j=i+1; j<=n; j++) {
        dsq = (x[i]-x[j])^2 + (y[i]-y[j])^2
        if (dsq < min) {
          min = dsq
          mini = i
          minj = j
        }
      }
    }
    printf("distance between (%.6f,%.6f) and (%.6f,%.6f) is %g\n",x[mini],y[mini],x[minj],y[minj],sqrt(min))
    exit(0)
}
