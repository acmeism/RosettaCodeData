# syntax: GAWK -f LARGEST_FIVE_ADJACENT_NUMBER.AWK
BEGIN {
    limit = 1000
    width = 5
    max_n = 0
    for (i=1; i<=width; i++) {
      min_n = min_n "9"
    }
    srand()
    for (i=1; i<=limit; i++) {
      digits = digits int(rand() * 10)
    }
    for (i=1; i<=limit-width+1; i++) {
      n = substr(digits,i,width)
      if (n > max_n) {
        max_n = n
        max_pos = i
      }
      if (n < min_n) {
        min_n = n
        min_pos = i
      }
    }
    printf("look for %d digit number using %d digits\n",width,limit)
    printf("largest  %0*d in positions %d-%d\n",width,max_n,max_pos,max_pos+width-1)
    printf("smallest %0*d in positions %d-%d\n",width,min_n,min_pos,min_pos+width-1)
    exit(0)
}
