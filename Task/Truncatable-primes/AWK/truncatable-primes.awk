# syntax: GAWK -f TRUNCATABLE_PRIMES.AWK
BEGIN {
    limit = 1000000
    for (i=1; i<=limit; i++) {
      if (is_prime(i)) {
        prime_count++
        arr[i] = ""
        if (truncate_left(i) == 1) {
          max_left = max(max_left,i)
        }
        if (truncate_right(i) == 1) {
          max_right = max(max_right,i)
        }
      }
    }
    printf("1-%d: %d primes\n",limit,prime_count)
    printf("largest L truncatable: %d\n",max_left)
    printf("largest R truncatable: %d\n",max_right)
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
function truncate_left(n) {
    while (n != "") {
      if (!(n in arr)) {
        return(0)
      }
      n = substr(n,2)
    }
    return(1)
}
function truncate_right(n) {
    while (n != "") {
      if (!(n in arr)) {
        return(0)
      }
      n = substr(n,1,length(n)-1)
    }
    return(1)
}
function max(x,y) { return((x > y) ? x : y) }
