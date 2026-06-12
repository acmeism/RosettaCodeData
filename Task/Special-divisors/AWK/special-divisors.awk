# syntax: GAWK -f SPECIAL_DIVISORS.AWK
# converted from C
BEGIN {
    start = 1
    stop = 200
    for (n=start; n<=stop; n++) {
        flag = 1
        rev_num = reverse(n)
        for (m=1; m<n/2; m++) {
          rev_div = reverse(m)
          if (n % m == 0) {
            if (rev_num % rev_div == 0) {
              flag = 1
            }
            else {
              flag = 0
              break
            }
          }
        }
        if (flag == 1) {
          printf("%5d%1s",n,++count%10?"":"\n")
        }
    }
    printf("\nSpecial divisors %d-%d: %d\n",start,stop,count)
    exit(0)
}
function reverse(n,  result) {
    while (n > 0) {
      result = 10 * result + n % 10
      n = int(n / 10)
    }
    return(result)
}
