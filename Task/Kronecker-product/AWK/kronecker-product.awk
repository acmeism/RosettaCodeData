# syntax: GAWK -f KRONECKER_PRODUCT.AWK
BEGIN {
    A[++a] = "1 2" ; B[++b] = "0 5"
    A[++a] = "3 4" ; B[++b] = "6 7"
    main("sample 1",1234)
    A[++a] = "0 1 0" ; B[++b] = "1 1 1 1"
    A[++a] = "1 1 1" ; B[++b] = "1 0 0 1"
    A[++a] = "0 1 0" ; B[++b] = "1 1 1 1"
    main("sample 2",3)
    exit(0)
}
function main(desc,option) {
#
# option: allows complete flexibility of output; they may be combined
#   1  show A and B matrix
#   2  show A x B
#   3  show product
#   4  show Arow,Acol x Brow,Bcol
#
    printf("%s\n\n",desc)
    if (option ~ /[1234]/) {
      a_rows = show_array(A,"A",option)
      b_rows = show_array(B,"B",option)
      if (option ~ /2/) { prn("A x B",2) }
      if (option ~ /3/) { prn("Product",3) }
      if (option ~ /4/) { prn("Arow,Acol x Brow,Bcol",4) }
    }
    else {
      print("nothing to print")
    }
    print("")
    a = b = 0 # reset
    delete A
    delete B
}
function prn(desc,option,  a_cols,b_cols,w,x,y,z,AA,BB) {
    printf("%s:\n",desc)
    for (w=1; w<=a_rows; w++) {
      a_cols = split(A[w],AA," ")
      for (x=1; x<=b_rows; x++) {
        b_cols = split(B[x],BB," ")
        printf("[ ")
        for (y=1; y<=a_cols; y++) {
          for (z=1; z<=b_cols; z++) {
            if (option ~ /2/) { printf("%sx%s ",AA[y],BB[z]) }
            if (option ~ /3/) { printf("%2s ",AA[y] * BB[z]) }
            if (option ~ /4/) { printf("%s,%sx%s,%s ",w,y,x,z) }
          }
        }
        printf("]\n")
      }
    }
}
function show_array(arr,desc,option,  i,n) {
    for (i in arr) {
      n++
    }
    if (option ~ /1/) {
      printf("Matrix %s:\n",desc)
      for (i=1; i<=n; i++) {
        printf("[ %s ]\n",arr[i])
      }
    }
    return(n)
}
