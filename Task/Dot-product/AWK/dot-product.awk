# syntax: GAWK -f DOT_PRODUCT.AWK
BEGIN {
    v1 = "1,3,-5"
    v2 = "4,-2,-1"
    if (split(v1,v1arr,",") != split(v2,v2arr,",")) {
      print("error: vectors are of unequal lengths")
      exit(1)
    }
    printf("%g\n",dot_product(v1arr,v2arr))
    exit(0)
}
function dot_product(v1,v2,  i,sum) {
    for (i in v1) {
      sum += v1[i] * v2[i]
    }
    return(sum)
}
