# syntax: GAWK -f ROMAN_NUMERALS_DECODE.AWK
BEGIN {
    leng = split("MCMXC MMVIII MDCLXVI",arr," ")
    for (i=1; i<=leng; i++) {
      n = arr[i]
      printf("%s = %s\n",n,roman2arabic(n))
    }
    exit(0)
}
function roman2arabic(r,  a,i,p,q,u,ua,una,unr) {
    r = toupper(r)
    unr = "MDCLXVI" # each Roman numeral in descending order
    una = "1000 500 100 50 10 5 1" # and its Arabic equivalent
    split(una,ua," ")
    i = split(r,u,"")
    a = ua[index(unr,u[i])]
    while (--i) {
      p = index(unr,u[i])
      q = index(unr,u[i+1])
      a += ua[p] * ((p>q) ? -1 : 1)
    }
    return( (a>0) ? a : "" )
}
