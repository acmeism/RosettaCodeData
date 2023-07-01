# syntax: GAWK -f JACOBI_SYMBOL.AWK
BEGIN {
    max_n = 29
    max_a = max_n + 1
    printf("n\\a")
    for (i=1; i<=max_a; i++) {
      printf("%3d",i)
      underline = underline " --"
    }
    printf("\n---%s\n",underline)
    for (n=1; n<=max_n; n+=2) {
      printf("%3d",n)
      for (a=1; a<=max_a; a++) {
        printf("%3d",jacobi(a,n))
      }
      printf("\n")
    }
    exit(0)
}
function jacobi(a,n,  result,tmp) {
    if (n%2 == 0) {
      print("error: 'n' must be a positive odd integer")
      exit
    }
    a %= n
    result = 1
    while (a != 0) {
      while (a%2 == 0) {
        a /= 2
        if (n%8 == 3 || n%8 == 5) {
          result = -result
        }
      }
      tmp = a
      a = n
      n = tmp
      if (a%4 == 3 && n%4 == 3) {
        result = -result
      }
      a %= n
    }
    if (n == 1) {
      return(result)
    }
    return(0)
}
