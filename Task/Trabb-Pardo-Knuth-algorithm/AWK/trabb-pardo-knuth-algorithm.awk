# syntax: GAWK -f TRABB_PARDO-KNUTH_ALGORITHM.AWK
BEGIN {
    printf("enter 11 numbers: ")
    getline S
    n = split(S,arr," ")
    if (n != 11) {
      printf("%d numbers entered; S/B 11\n",n)
      exit(1)
    }
    for (i=n; i>0; i--) {
      x = f(arr[i])
      printf("f(%s) = %s\n",arr[i],(x>400) ? "too large" : x)
    }
    exit(0)
}
function abs(x) { if (x >= 0) { return x } else { return -x } }
function f(x) { return sqrt(abs(x)) + 5 * x ^ 3 }
