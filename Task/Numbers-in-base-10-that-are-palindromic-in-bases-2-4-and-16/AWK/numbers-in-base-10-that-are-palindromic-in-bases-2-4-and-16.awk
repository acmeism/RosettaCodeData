# syntax: GAWK -f NUMBERS_IN_BASE_10_THAT_ARE_PALINDROMIC_IN_BASES_2_4_AND_16.AWK
# converted from C
BEGIN {
    start = 0
    stop = 24999
    for (i=start; i<stop; i++) {
      if (palindrome(i,2) && palindrome(i,4) && palindrome(i,16)) {
         printf("%5d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nBase 10 numbers that are palindromes in bases 2, 4, and 16: %d-%d: %d\n",start,stop,count)
    exit(0)
}
function palindrome(n,base) {
    return n == reverse(n,base)
}
function reverse(n,base,  r) {
    for (r=0; n; n=int(n/base)) {
      r = int(r*base) + n%base
    }
    return(r)
}
