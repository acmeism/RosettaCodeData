# syntax: GAWK -f PADOVAN_N-STEP_NUMBER_SEQUENCES.AWK
# converted from C
BEGIN {
    split("A134816,A000930,A072465,A060961,N/A,A117760,N/A",arr,",")
    t = 15 # terms
    printf("First %d terms of the Padovan n-step sequences and OEIS entry:\n",t)
    for (n=2; n<=8; n++) {
      padovanN(n)
      printf("%d:",n)
      for (i=0; i<t; i++) {
        printf("%4d",p[i])
      }
      printf("  %s\n",arr[n-1])
    }
    exit(0)
}
function padovanN(n,  i,j) {
    if (n < 2 || t < 3) {
      for (i=0; i<t; i++) {
        p[i] = 1
      }
      return
    }
    padovanN(n-1)
    for (i=n+1; i<t; i++) {
      p[i] = 0
      for (j=i-2; j>=i-n-1; j--) {
        p[i] += p[j]
      }
    }
}
