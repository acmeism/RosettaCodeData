# syntax: GAWK -f NUMBERS_N_IN_WHICH_NUMBER_1_OCCUR_TWICE.AWK
BEGIN {
    start = 1
    stop = 999
    for (i=start; i<=stop; i++) {
      if (gsub(/1/,"&",i) == 2) {
        printf("%4d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nNumber 1 occurs twice %d-%d: %d\n",start,stop,count)
    exit(0)
}
