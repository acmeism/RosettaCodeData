# syntax: GAWK -f LEONARDO_NUMBERS.AWK
BEGIN {
    leonardo(1,1,1,"Leonardo")
    leonardo(0,1,0,"Fibonacci")
    exit(0)
}
function leonardo(L0,L1,step,text,  i,tmp) {
    printf("%s numbers (%d,%d,%d):\n",text,L0,L1,step)
    for (i=1; i<=25; i++) {
      if (i == 1) {
        printf("%d ",L0)
      }
      else if (i == 2) {
        printf("%d ",L1)
      }
      else {
        printf("%d ",L0+L1+step)
        tmp = L0
        L0 = L1
        L1 = tmp + L1 + step
      }
    }
    printf("\n")
}
