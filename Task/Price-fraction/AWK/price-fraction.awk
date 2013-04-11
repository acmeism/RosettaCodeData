BEGIN {
    O = ".06 .11 .16 .21 .26 .31 .36 .41 .46 .51 .56 .61 .66 .71 .76 .81 .86 .91 .96 1.01"
    N = ".10 .18 .26 .32 .38 .44 .50 .54 .58 .62 .66 .70 .74 .78 .82 .86 .90 .94 .98 1.00"
    fields = split(O,Oarr," ") # original values
    split(N,Narr," ") # replacement values
    for (i=-.01; i<=1.02; i+=.01) { # test
      printf("%5.2f = %4.2f\n",i,lookup(i))
    }
}
function lookup(n,  i) {
    if (n < 0 || n > 1.01) {
      return(0) # when input is out of range
    }
    for (i=1; i<=fields; i++) {
      # +10 is used because .11 returned .18 instead of .26
      # under AWK95, GAWK, and MAWK; Thompson Automation's TAWK worked correctly
      if (n+10 < Oarr[i]+10) {
        return(Narr[i])
      }
    }
}
