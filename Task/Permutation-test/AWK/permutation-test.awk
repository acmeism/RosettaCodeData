# syntax: GAWK -f PERMUTATION_TEST.AWK
# converted from C
BEGIN {
#             "treatment..................control......................"
    n = split("85,88,75,66,25,29,83,39,97,68,41,10,49,16,65,32,92,28,98",data,",")
    for (i=1; i<=n; i++) { # make AWK array look like a C array
      data[i-1] = data[i]
    }
    delete data[n]
    total = 1
    for (i=0; i<9; i++) { treat += data[i] }
    for (i=19; i>10; i--) { total *= i }
    for (i=9; i>0; i--) { total /= i }
    gt = pick(19,9,0,treat)
    le = total - gt
    printf("<= : %9.6f%% %6d\n",100*le/total,le)
    printf(" > : %9.6f%% %6d\n",100*gt/total,gt)
    exit(0)
}
function pick(at,remain,accu,treat) {
    if (!remain) {
      return (accu > treat) ? 1 : 0
    }
    return pick(at-1,remain-1,accu+data[at-1],treat) + ( (at > remain) ? pick(at-1,remain,accu,treat) : 0 )
}
