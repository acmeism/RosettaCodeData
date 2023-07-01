# syntax: GAWK -f CULLEN_AND_WOODALL_NUMBERS.AWK
BEGIN {
    start = 1
    stop = 20
    printf("Cullen %d-%d:",start,stop)
    for (n=start; n<=stop; n++) {
      printf(" %d",n*(2^n)+1)
    }
    printf("\n")
    printf("Woodall %d-%d:",start,stop)
    for (n=start; n<=stop; n++) {
      printf(" %d",n*(2^n)-1)
    }
    printf("\n")
    exit(0)
}
