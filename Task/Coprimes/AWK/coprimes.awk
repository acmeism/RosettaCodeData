# syntax: GAWK -f COPRIMES.AWK
BEGIN {
    n = split("21,15;17,23;36,12;18,29;60,15",arr1,";")
    for (i=1; i<=n; i++) {
      split(arr1[i],arr2,",")
      a = arr2[1]
      b = arr2[2]
      if (gcd(a,b) == 1) {
        printf("%d %d\n",a,b)
      }
    }
    exit(0)
}
function gcd(p,q) {
    return(q?gcd(q,(p%q)):p)
}
