# syntax: GAWK -f NARCISSISTIC_DECIMAL_NUMBER.AWK
BEGIN {
    for (n=0;;n++) {
      leng = length(n)
      sum = 0
      for (i=1; i<=leng; i++) {
        c = substr(n,i,1)
        sum += c ^ leng
      }
      if (n == sum) {
        printf("%d ",n)
        if (++count == 25) { break }
      }
    }
    exit(0)
}
