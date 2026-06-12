# syntax: GAWK -f IDONEAL_NUMBERS.AWK
# converted from Go
BEGIN {
    print("The 65 known Idoneal numbers:")
    for (n=1; n<=1850; n++) {
      if (is_idoneal(n)) {
        printf("%5d",n)
        if (++r % 13 == 0) { print("") }
      }
    }
    exit(0)
}
function is_idoneal(n,  a,b,c,sum) {
    for (a=1; a<n; a++) {
      for (b=a+1; b<n; b++) {
        if (a*b+a+b > n) { break }
        for (c=b+1; c<n; c++) {
          sum = a*b + b*c + a*c
          if (sum == n) { return(0) }
          if (sum > n) { break }
        }
      }
    }
    return(1)
}
