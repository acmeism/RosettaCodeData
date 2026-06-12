# syntax: GAWK -f SUM_OF_FIRST_N_CUBES.AWK
BEGIN {
    start = 0
    stop = 49
    for (i=start; i<=stop; i++) {
      sum += i * i * i
      printf("%7d%1s",sum,++count%10?"":"\n")
    }
    printf("\nSum of cubes %d-%d: %d\n",start,stop,count)
    exit(0)
}
