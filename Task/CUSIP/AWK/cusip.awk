# syntax: GAWK -f CUSIP.AWK
BEGIN {
    n = split("037833100,17275R102,38259P508,594918104,68389X106,68389X105",arr,",")
    for (i=1; i<=n; i++) {
      printf("%9s %s\n",arr[i],cusip(arr[i]))
    }
    exit(0)
}
function cusip(n,  c,i,sum,v,x) {
# returns: 1=OK, 0=NG, -1=bad data
    if (length(n) != 9) {
      return(-1)
    }
    for (i=1; i<=8; i++) {
      c = substr(n,i,1)
      if (c ~ /[0-9]/) {
        v = c
      }
      else if (c ~ /[A-Z]/) {
        v = index("ABCDEFGHIJKLMNOPQRSTUVWXYZ",c) + 9
      }
      else if (c == "*") {
        v = 36
      }
      else if (c == "@") {
        v = 37
      }
      else if (c == "#") {
        v = 38
      }
      else {
        return(-1)
      }
      if (i ~ /[02468]/) {
        v *= 2
      }
      sum += int(v / 10) + (v % 10)
    }
    x = (10 - (sum % 10)) % 10
    return(substr(n,9,1) == x ? 1 : 0)
}
