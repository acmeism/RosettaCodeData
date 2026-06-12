# syntax: GAWK -f SUM_OF_THE_DIGITS_OF_N_IS_SUBSTRING_OF_N.AWK
BEGIN {
    start = 0
    stop = 999
    for (i=start; i<=stop; i++) {
      if (i ~ ""sum_digits(i)) { # TAWK needs the ""
        printf("%4d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nSum of the digits of n is substring of n %d-%d: %d\n",start,stop,count)
    exit(0)
}
function sum_digits(n,  i,sum) {
    for (i=1; i<=length(n); i++) {
      sum += substr(n,i,1)
    }
    return(sum)
}
