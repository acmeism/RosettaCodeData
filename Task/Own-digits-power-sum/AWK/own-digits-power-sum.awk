# syntax: GAWK -f OWN_DIGITS_POWER_SUM.AWK
# converted from FreeBASIC
BEGIN {
    for (n=3; n<=8; n++) {
      for (curr=10^(n-1); curr<=10^n-1; curr++) {
        sum = 0
        tmp = curr
        do {
          dig = tmp % 10
          tmp = int(tmp / 10)
          sum += dig ^ n
        } while (tmp != 0)
        if (sum == curr) {
          leng = length(curr)
          if (leng > prev_leng) {
            printf("\n%d:",leng)
            prev_leng = leng
          }
          printf(" %d",curr)
        }
      }
    }
    printf("\n")
    exit(0)
}
