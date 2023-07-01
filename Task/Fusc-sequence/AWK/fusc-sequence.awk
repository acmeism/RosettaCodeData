# syntax: GAWK -f FUSC_SEQUENCE.AWK
# converted from C
BEGIN {
    for (i=0; i<61; i++) {
      printf("%d ",fusc(i))
    }
    printf("\n")
    print("fusc numbers whose length is greater than any previous fusc number length")
    printf("%9s %9s\n","fusc","index")
    for (i=0; i<=700000; i++) {
      f = fusc(i)
      leng = num_leng(f)
      if (leng > max_leng) {
        max_leng = leng
        printf("%9s %9s\n",commatize(f),commatize(i))
      }
    }
    exit(0)
}
function commatize(x,  num) {
    if (x < 0) {
      return "-" commatize(-x)
    }
    x = int(x)
    num = sprintf("%d.",x)
    while (num ~ /^[0-9][0-9][0-9][0-9]/) {
      sub(/[0-9][0-9][0-9][,.]/,",&",num)
    }
    sub(/\.$/,"",num)
    return(num)
}
function fusc(n) {
    if (n == 0 || n == 1) {
      return(n)
    }
    else if (n % 2 == 0) {
      return fusc(n/2)
    }
    else {
      return fusc((n-1)/2) + fusc((n+1)/2)
    }
}
function num_leng(n,  sum) {
    sum = 1
    while (n > 9) {
      n = int(n/10)
      sum++
    }
    return(sum)
}
