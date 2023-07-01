# syntax: GAWK -f ABUNDANT_ODD_NUMBERS.AWK
# converted from C
BEGIN {
    print("   index     number        sum")
    fmt = "%8s %10d %10d\n"
    n = 1
    for (c=0; c<25; n+=2) {
      if (n < sum_proper_divisors(n)) {
        printf(fmt,++c,n,sum)
      }
    }
    for (; c<1000; n+=2) {
      if (n < sum_proper_divisors(n)) {
        c++
      }
    }
    printf(fmt,1000,n-2,sum)
    for (n=1000000001; ; n+=2) {
      if (n < sum_proper_divisors(n)) {
        break
      }
    }
    printf(fmt,"1st > 1B",n,sum)
    exit(0)
}
function sum_proper_divisors(n,  j) {
    sum = 1
    for (i=3; i<sqrt(n)+1; i+=2) {
      if (n % i == 0) {
        sum += i + (i == (j = n / i) ? 0 : j)
      }
    }
    return(sum)
}
