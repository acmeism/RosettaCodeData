# syntax: GAWK -f PANCAKE_NUMBERS.AWK
# converted from C
BEGIN {
    for (i=0; i<4; i++) {
      for (j=1; j<6; j++) {
        n = i * 5 + j
        printf("p(%2d) = %2d  ",n,main(n))
      }
      printf("\n")
    }
    exit(0)
}
function main(n,  adj,gap,sum) {
    gap = 2
    sum = 2
    adj = -1
    while (sum < n) {
      adj++
      gap = gap * 2 - 1
      sum += gap
    }
    return(n + adj)
}
