# syntax: GAWK -f EULERS_SUM_OF_POWERS_CONJECTURE.AWK
BEGIN {
    start_int = systime()
    main()
    printf("%d seconds\n",systime()-start_int)
    exit(0)
}
function main(  sum,s1,x0,x1,x2,x3) {
    for (x0=1; x0<=250; x0++) {
      for (x1=1; x1<=x0; x1++) {
        for (x2=1; x2<=x1; x2++) {
          for (x3=1; x3<=x2; x3++) {
            sum = (x0^5) + (x1^5) + (x2^5) + (x3^5)
            s1 = int(sum ^ 0.2)
            if (sum == s1^5) {
              printf("%d^5 + %d^5 + %d^5 + %d^5 = %d^5\n",x0,x1,x2,x3,s1)
              return
            }
          }
        }
      }
    }
}
