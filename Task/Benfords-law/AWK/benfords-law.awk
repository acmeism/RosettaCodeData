# syntax: GAWK -f BENFORDS_LAW.AWK
BEGIN {
    n = 1000
    for (i=1; i<=n; i++) {
      arr[substr(fibonacci(i),1,1)]++
    }
    print("digit expected observed deviation")
    for (i=1; i<=9; i++) {
      expected = log10(i+1) - log10(i)
      actual = arr[i] / n
      deviation = expected - actual
      printf("%5d %8.4f %8.4f %9.4f\n",i,expected*100,actual*100,abs(deviation*100))
    }
    exit(0)
}
function fibonacci(n,  a,b,c,i) {
    a = 0
    b = 1
    for (i=1; i<=n; i++) {
      c = a + b
      a = b
      b = c
    }
    return(c)
}
function abs(x) { if (x >= 0) { return x } else { return -x } }
function log10(x) { return log(x)/log(10) }
