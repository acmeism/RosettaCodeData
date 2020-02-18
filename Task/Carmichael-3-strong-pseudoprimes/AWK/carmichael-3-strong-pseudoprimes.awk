# syntax: GAWK -f CARMICHAEL_3_STRONG_PSEUDOPRIMES.AWK
# converted from C
BEGIN {
    printf("%5s%8s%8s%13s\n","P1","P2","P3","PRODUCT")
    for (p1=2; p1<62; p1++) {
      if (!is_prime(p1)) { continue }
      for (h3=1; h3<p1; h3++) {
        for (d=1; d<h3+p1; d++) {
          if ((h3+p1)*(p1-1)%d == 0 && mod(-p1*p1,h3) == d%h3) {
            p2 = int(1+((p1-1)*(h3+p1)/d))
            if (!is_prime(p2)) { continue }
            p3 = int(1+(p1*p2/h3))
            if (!is_prime(p3) || (p2*p3)%(p1-1) != 1) { continue }
            printf("%5d x %5d x %5d = %10d\n",p1,p2,p3,p1*p2*p3)
            count++
          }
        }
      }
    }
    printf("%d numbers\n",count)
    exit(0)
}
function is_prime(n,  i) {
    if (n <= 3) {
      return(n > 1)
    }
    else if (!(n%2) || !(n%3)) {
      return(0)
    }
    else {
      for (i=5; i*i<=n; i+=6) {
        if (!(n%i) || !(n%(i+2))) {
          return(0)
        }
      }
      return(1)
    }
}
function mod(n,m) {
# the % operator actually calculates the remainder of a / b so we need a small adjustment so it works as expected for negative values
    return(((n%m)+m)%m)
}
