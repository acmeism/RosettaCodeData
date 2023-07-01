# syntax: GAWK -f SEXY_PRIMES.AWK
BEGIN {
    cutoff = 1000034
    for (i=1; i<=cutoff; i++) {
      n1 = i
      if (is_prime(n1)) {
        total_primes++
        if ((n2 = n1 + 6) > cutoff) { continue }
        if (is_prime(n2)) {
          save(2,5,n1 FS n2)
          if ((n3 = n2 + 6) > cutoff) { continue }
          if (is_prime(n3)) {
            save(3,5,n1 FS n2 FS n3)
            if ((n4 = n3 + 6) > cutoff) { continue }
            if (is_prime(n4)) {
              save(4,5,n1 FS n2 FS n3 FS n4)
              if ((n5 = n4 + 6) > cutoff) { continue }
              if (is_prime(n5)) {
                save(5,5,n1 FS n2 FS n3 FS n4 FS n5)
              }
            }
          }
        }
        if ((s[2] s[3] s[4] s[5]) !~ (n1 "")) { # check for unsexy
          save(1,10,n1)
        }
      }
    }
    printf("%d primes less than %s\n\n",total_primes,cutoff+1)
    printf("%d unsexy primes\n%s\n\n",c[1],s[1])
    printf("%d sexy prime pairs\n%s\n\n",c[2],s[2])
    printf("%d sexy prime triplets\n%s\n\n",c[3],s[3])
    printf("%d sexy prime quadruplets\n%s\n\n",c[4],s[4])
    printf("%d sexy prime quintuplets\n%s\n\n",c[5],s[5])
    exit(0)
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
function save(key,nbr_to_keep,str) {
    c[key]++
    str = s[key] str ", "
    if (gsub(/,/,"&",str) > nbr_to_keep) {
      str = substr(str,index(str,",")+2)
    }
    s[key] = str
}
