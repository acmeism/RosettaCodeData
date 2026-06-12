# syntax: GAWK -f DIGIT_FIFTH_POWERS.AWK
BEGIN {
    for (p=3; p<=6; p++) {
      limit = 9^p*p
      sum = 0
      for (i=2; i<=limit; i++) {
        if (i == main(i)) {
          printf("%6d\n",i)
          sum += i
        }
      }
      printf("%6d power %d sum\n\n",sum,p)
    }
    exit(0)
}
function main(n,  i,total) {
    for (i=1; i<=length(n); i++) {
      total += substr(n,i,1) ^ p
    }
    return(total)
}
