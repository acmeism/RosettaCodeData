# syntax: GAWK -f LARGEST_PALINDROME_PRODUCT.AWK
BEGIN {
    main(9)
    main(99)
    main(999)
    main(9999)
    exit(0)
}
function main(n,  i,j,max_i,max_j,max_product,product) {
    for (i=1; i<=n; i++) {
      for (j=1; j<=n; j++) {
        product = i * j
        if (product > max_product) {
          if (product ~ /^9/ && product ~ /9$/) {
            if (product == reverse(product)) {
              max_product = product
              max_i = i
              max_j = j
            }
          }
        }
      }
    }
    printf("%1d: %4s * %-4s = %d\n",length(n),max_i,max_j,max_product)
}
function reverse(str,  i,rts) {
    for (i=length(str); i>=1; i--) {
      rts = rts substr(str,i,1)
    }
    return(rts)
}
