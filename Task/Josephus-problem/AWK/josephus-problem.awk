# syntax: GAWK -f JOSEPHUS_PROBLEM.AWK
# converted from PL/I
BEGIN {
    main(5,2,1)
    main(41,3,1)
    main(41,3,3)
    exit(0)
}
function main(n,k,s,  dead,errors,found,i,killed,nn,p,survived) {
# n - number of prisoners
# k - kill every k'th prisoner
# s - number of survivors
    printf("\nn=%d k=%d s=%d\n",n,k,s) # show arguments
    if (s > n) { print("s>n"); errors++ }
    if (k <= 0) { print("k<=0"); errors++ }
    if (errors > 0) { return(0) }
    nn = n                             # wrap around boundary
    p = -1                             # start here
    while (n != s) {                   # until survivor count is met
      found = 0                        # start looking
      while (found != k) {             # until we have the k-th prisoner
        if (++p == nn) { p = 0 }       # wrap around
        if (dead[p] != 1) { found++ }  # if prisoner is alive increment found
      }
      dead[p] = 1                      # kill the unlucky one
      killed = killed p " "            # build killed list
      n--                              # reduce size of circle
    }
    for (i=0; i<=nn-1; i++) {
      if (dead[i] != 1) {
        survived = survived i " "      # build survivor list
      }
    }
    printf("killed: %s\n",killed)
    printf("survived: %s\n",survived)
    return(1)
}
