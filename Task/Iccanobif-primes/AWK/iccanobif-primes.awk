# syntax: GAWK -f ICCANOBIF_PRIMES.AWK
BEGIN {
    fibonacci()
    while (stop < 10) {
      n++
      if (is_prime(n) && reverse(n) in fib_arr) {
        printf("%d ",n)
        stop++
      }
    }
    printf("\n")
    exit(0)
}
function fibonacci(  f0,f1,i,newf) {
    f0 = 0
    f1 = 1
    for (i=1; i<=99; i++) {
      newf = f0 + f1
      f0 = f1
      f1 = newf
      fib_arr[newf] = i
    }
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
function reverse(str,  i,rts) {
    for (i=length(str); i>=1; i--) {
      rts = rts substr(str,i,1)
    }
    return(rts)
}
