# syntax: GAWK -f PRIME_NUMBERS_OF_MEASUREMENT.AWK
# converted from FreeBASIC
BEGIN {
    prime_measure[0] = 1
    idx++
    for (next_num=2; next_num<=1000000; next_num++) {
      last = 0
      for (start=0; start<=idx-1; start++) {
        sum = prime_measure[start]
        for (end_num=start+1; end_num<=idx-1; end_num++) {
          sum += prime_measure[end_num]
          if (sum > next_num) { break }
          if (sum == next_num) {
            last = 1
            break
          }
        }
        if (last == 1) { break }
      }
      if (last == 0) {
        prime_measure[idx] = next_num
        if (++idx >= 1000) { break }
      }
    }
    for (i=0; i<=99; i++) {
      printf("%4d%s",prime_measure[i],(i+1)%10?"":"\n")
    }
    printf("\n1000th %d\n",prime_measure[999])
    exit(0)
}
