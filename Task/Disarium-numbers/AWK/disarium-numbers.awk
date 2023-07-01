# syntax: GAWK -f DISARIUM_NUMBERS.AWK
BEGIN {
    stop = 19
    printf("The first %d Disarium numbers:\n",stop)
    while (count < stop) {
      if (is_disarium(n)) {
        printf("%d ",n)
        count++
      }
      n++
    }
    printf("\n")
    exit(0)
}
function is_disarium(n,  leng,sum,x) {
    x = n
    leng = length(n)
    while (x != 0) {
      sum += (x % 10) ^ leng
      leng--
      x = int(x/10)
    }
    return((sum == n) ? 1 : 0)
}
