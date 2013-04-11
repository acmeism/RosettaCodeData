# syntax: GAWK -f SELF-DESCRIBING_NUMBERS.AWK
BEGIN {
    for (n=1; n<=100000000; n++) {
      if (is_self_describing(n)) {
        print(n)
      }
    }
    exit(0)
}
function is_self_describing(n,  i) {
    for (i=1; i<=length(n); i++) {
      if (substr(n,i,1) != gsub(i-1,"&",n)) {
        return(0)
      }
    }
    return(1)
}
