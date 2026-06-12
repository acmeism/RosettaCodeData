# syntax: GAWK -f STRANGE_UNIQUE_PRIME_TRIPLETS.AWK
# converted from Go
BEGIN {
    main(29,1)
    main(999,0)
    exit(0)
}
function main(n,show,  count,i,j,k,s) {
    for (i=3; i<=n-4; i+=2) {
      if (is_prime(i)) {
        for (j=i+2; j<=n-2; j+=2) {
          if (is_prime(j)) {
            for (k=j+2; k<=n; k+=2) {
              if (is_prime(k)) {
                s = i + j + k
                if (is_prime(s)) {
                  count++
                  if (show == 1) {
                    printf("%2d + %2d + %2d = %d\n",i,j,k,s)
                  }
                }
              }
            }
          }
        }
      }
    }
    printf("Unique prime triples 2-%d which sum to a prime: %'d\n\n",n,count)
}
function is_prime(x,  i) {
    if (x <= 1) {
      return(0)
    }
    for (i=2; i<=int(sqrt(x)); i++) {
      if (x % i == 0) {
        return(0)
      }
    }
    return(1)
}
