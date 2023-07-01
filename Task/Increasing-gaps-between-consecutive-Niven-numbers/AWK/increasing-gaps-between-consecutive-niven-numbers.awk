# syntax: GAWK -f INCREASING_GAPS_BETWEEN_CONSECUTIVE_NIVEN_NUMBERS.AWK
# converted from C
BEGIN {
    gap_index = 1
    previous = 1
    print("Gap index  Gap  Niven index  Niven number")
    print("---------  ---  -----------  ------------")
    for (niven=1; gap_index<=22; niven++) {
      sum = digit_sum(niven,sum)
      if (divisible(niven,sum)) {
        if (niven > previous + gap) {
          gap = niven - previous
          printf("%9d %4d %12d %13d\n",gap_index++,gap,niven_index,previous)
        }
        previous = niven
        niven_index++
      }
    }
    exit(0)
}
function digit_sum(n,sum) {
# returns the sum of the digits of n given the sum of the digits of n - 1
    sum++
    while (n > 0 && n % 10 == 0) {
      sum -= 9
      n = int(n / 10)
    }
    return(sum)
}
function divisible(n,d) {
    if (and(d,1) == 0 && and(n,1) == 1) {
      return(0)
    }
    return(n % d == 0)
}
