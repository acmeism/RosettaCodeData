# syntax: GAWK -f CHOWLA_NUMBERS.AWK
# converted from Go
BEGIN {
    for (i=1; i<=37; i++) {
      printf("chowla(%2d) = %s\n",i,chowla(i))
    }
    printf("\nCount of primes up to:\n")
    count = 1
    limit = 1e7
    sieve(limit)
    power = 100
    for (i=3; i<limit; i+=2) {
      if (!c[i]) {
        count++
      }
      if (i == power-1) {
        printf("%10s = %s\n",commatize(power),commatize(count))
        power *= 10
      }
    }
    printf("\nPerfect numbers:")
    count = 0
    limit = 35000000
    k = 2
    kk = 3
    while (1) {
      if ((p = k * kk) > limit) {
        break
      }
      if (chowla(p) == p-1) {
        printf("  %s",commatize(p))
        count++
      }
      k = kk + 1
      kk += k
    }
    printf("\nThere are %d perfect numbers <= %s\n",count,commatize(limit))
    exit(0)
}
function chowla(n,  i,j,sum) {
    if (n < 1 || n != int(n)) {
      return sprintf("%s is invalid",n)
    }
    for (i=2; i*i<=n; i++) {
      if (n%i == 0) {
        j = n / i
        sum += (i == j) ? i : i + j
      }
    }
    return(sum+0)
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
function sieve(limit,  i,j) {
    for (i=1; i<=limit; i++) {
      c[i] = 0
    }
    for (i=3; i*3<limit; i+=2) {
      if (!c[i] && chowla(i) == 0) {
        for (j=3*i; j<limit; j+=2*i) {
          c[j] = 1
        }
      }
    }
}
