# syntax: GAWK -f SPECIAL_FACTORIALS.AWK
# converted from LUA
BEGIN {
    test_factorial(9,"super_factorial")
    test_factorial(8,"hyper_factorial")
    test_factorial(10,"alternating_factorial")
    test_factorial(5,"exponential_factorial")
    n = split("1,2,6,24,120,720,5040,40320,362880,3628800,119",arr,",")
    for (i=1; i<=n; i++) {
      test_inverse(arr[i])
    }
    exit(0)
}
function alternating_factorial(n,  i,result) {
# af(n) = -1^(n-1)*1! + -1^(n-1)*2! + ... + -1^(1)*(n-1)! + -1^(0)*n!
    result = 0
    for (i=1; i<=n; i++) {
      if ((n-i) % 2 == 0) {
        result += factorial(i)
      }
      else {
        result -= factorial(i)
      }
    }
    return(result)
}
function exponential_factorial(n,  i,result) {
# n$ = n ^ (n-1) ^ ... ^ 2 ^ 1
    result = 0
    for (i=1; i<=n; i++) {
      result = i ^ result
    }
    return(result)
}
function factorial(n,  i,result) {
# n! = 1 * 2 * 3 * ... * n-1 * n
    result = 1
    i = 1
    while (i <= n) {
      result *= i
      i++
    }
    return(result)
}
function hyper_factorial(n,  i,result) {
# H(n) = 1^1 * 2^2 * 3^3 * ... * (n-1)^(n-1) * n^n
    result = 1
    for (i=1; i<=n; i++) {
      result *= i ^ i
    }
    return(result)
}
function inverse_factorial(f,  i,p) {
# if(n!) = n
    p = 1
    i = 1
    if (f == 1) {
      return(0)
    }
    while (p < f) {
      p *= i
      i++
    }
    if (p == f) {
      return(i-1)
    }
    return(-1)
}
function super_factorial(n,  i,result) {
# sf(n) = 1! * 2! * 3! * ... * (n-1)! * n!
    result = 1
    i = 1
    while (i <= n) {
      result *= factorial(i)
      i++
    }
    return result
}
function test_factorial(count,f,  i) {
    printf("First %d %ss:\n",count,f)
    for (i=1; i<=count; i++) {
      printf("%s ",floor(@f(i-1)))
    }
    printf("\n\n")
}
function test_inverse(f,  n) {
    n = inverse_factorial(f)
    if (n < 0) {
      printf("rf(%s) = No Solution\n",f)
    }
    else {
      printf("rf(%d) = %d\n",f,n)
    }
}
function floor(x, y) { y=int(x) ; return (y>x)?y-1:y }
