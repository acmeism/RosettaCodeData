# syntax: GAWK -f FACTORS_OF_AN_INTEGER.AWK
BEGIN {
    print("enter a number or C/R to exit")
}
{   if ($0 == "") { exit(0) }
    if ($0 !~ /^[0-9]+$/) {
      printf("invalid: %s\n",$0)
      next
    }
    n = $0
    printf("factors of %s:",n)
    for (i=1; i<=n; i++) {
      if (n % i == 0) {
        printf(" %d",i)
      }
    }
    printf("\n")
}
