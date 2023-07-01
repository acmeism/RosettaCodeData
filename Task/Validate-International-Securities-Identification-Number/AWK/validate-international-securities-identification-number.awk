# syntax: GAWK -f VALIDATE_INTERNATIONAL_SECURITIES_IDENTIFICATION_NUMBER.AWK
# converted from Fortran
BEGIN {
    for (i=0; i<=255; i++) { ord_arr[sprintf("%c",i)] = i } # build array[character]=ordinal_value
    n = split("US0378331005,US0373831005,U50378331005,US03378331005,AU0000XVGZA3,AU0000VXGZA3,FR0000988040",arr,",")
    for (i=1; i<=n; i++) {
      printf("%s %s\n",is_isin(arr[i]),arr[i])
    }
    exit(0)
}
function is_isin(arg,  i,j,k,s,v) {
    for (i=1; i<=12; i++) { # convert to an array of digits
      k = ord_arr[substr(arg,i,1)]
      if (k >= 48 && k <= 57) {
        if (i < 3) { return(0) }
        k -= 48
        s[++j] = k
      } else if (k >= 65 && k <= 90) {
        if (i == 12) { return(0) }
        k = k - 65 + 10
        s[++j] = int(k / 10)
        s[++j] = k % 10
      } else {
        return(0)
      }
    }
    for (i=j-1; i>=1; i-=2) { # compute checksum
      k = 2 * s[i]
      if (k > 9) { k -= 9 }
      v += k
    }
    for (i=j; i>=1; i-=2) {
      v += s[i]
    }
    return(v % 10 == 0)
}
