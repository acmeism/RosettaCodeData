# syntax: GAWK -f DECIMAL_-_HEXADECIMAL_NUMBERS.AWK
BEGIN {
    start = 0
    stop = 99999
    for (i=start; i<=stop; i++) {
      tmp = sprintf("%X",i)
      leng_dec = length(i)
      leng_hex = length(tmp)
      hits_dec = hits_hex = 0
      for (j=1; j<=leng_dec; j++) {
        if (tmp ~ substr(i,j,1)) {
          hits_dec++
        }
      }
      if (leng_dec == hits_dec) {
        for (j=1; j<=leng_hex; j++) {
          if (i ~ substr(tmp,j,1)) {
            hits_hex++
          }
        }
      }
      if (leng_hex == hits_hex) {
        printf("%6d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nDecimal matches hexadecimal %d-%d: %d\n",start,stop,count)
    exit(0)
}
