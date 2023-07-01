# syntax: GAWK -f REPEAT.AWK
BEGIN {
    for (i=0; i<=3; i++) {
      f = (i % 2 == 0) ? "even" : "odd"
      @f(i) # indirect function call
    }
    exit(0)
}
function even(n,  i) {
    for (i=1; i<=n; i++) {
      printf("inside even %d\n",n)
    }
}
function odd(n,  i) {
    for (i=1; i<=n; i++) {
      printf("inside odd %d\n",n)
    }
}
