# syntax: GAWK -f TWO_IDENTICAL_STRINGS.AWK
BEGIN {
    for (i=1; i<1000; i++) {
      b = dec2bin(i)
      leng = length(b)
      if (leng % 2 == 0) {
        if (substr(b,1,leng/2) == substr(b,leng/2+1)) {
          printf("%4d %10s\n",i,b)
          count++
        }
      }
    }
    printf("count: %d\n",count)
    exit(0)
}
function dec2bin(n,  str) {
    while (n) {
      str = ((n%2 == 0) ? "0" : "1") str
      n = int(n/2)
    }
    if (str == "") {
      str = "0"
    }
    return(str)
}
