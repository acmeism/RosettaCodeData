# syntax: GAWK -f VAN_DER_CORPUT_SEQUENCE.AWK
# converted from BBC BASIC
BEGIN {
    printf("base")
    for (i=0; i<=9; i++) {
      printf(" %7d",i)
    }
    printf("\n")
    for (base=2; base<=5; base++) {
      printf("%-4s",base)
      for (i=0; i<=9; i++) {
        printf(" %7.5f",vdc(i,base))
      }
      printf("\n")
    }
    exit(0)
}
function vdc(n,b,  s,v) {
    s = 1
    while (n) {
      s *= b
      v += (n % b) / s
      n /= b
      n = int(n)
    }
    return(v)
}
