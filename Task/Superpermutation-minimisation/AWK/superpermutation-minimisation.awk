# syntax: GAWK -f SUPERPERMUTATION_MINIMISATION.AWK
# converted from C
BEGIN {
    arr[0] # prevents fatal: attempt to use scalar 'arr' as an array
    limit = 11
    for (n=0; n<=limit; n++) {
      leng = super_perm(n)
      printf("%2d %d ",n,leng)
#     for (i=0; i<length(arr); i++) { printf(arr[i]) } # un-comment to see the string
      printf("\n")
    }
    exit(0)
}
function fact_sum(n,  f,s,x) {
    f = 1
    s = x = 0
    for (;x<n;) {
      f *= ++x
      s += f
    }
    return(s)
}
function super_perm(n,  i,leng) {
    delete arr
    pos = n
    leng = fact_sum(n)
    for (i=0; i<leng; i++) {
      arr[i] = ""
    }
    for (i=0; i<=n; i++) {
      cnt[i] = i
    }
    for (i=1; i<=n; i++) {
      arr[i-1] = i + "0"
    }
    while (r(n)) { }
    return(leng)
}
function r(n,  c) {
    if (!n) { return(0) }
    c = arr[pos-n]
    if (!--cnt[n]) {
      cnt[n] = n
      if (!r(n-1)) { return(0) }
    }
    arr[pos++] = c
    return(1)
}
