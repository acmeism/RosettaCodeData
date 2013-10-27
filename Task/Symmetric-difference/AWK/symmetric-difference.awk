# syntax: GAWK -f SYMMETRIC_DIFFERENCE.AWK
BEGIN {
    load("John,Bob,Mary,Serena",A)
    load("Jim,Mary,John,Bob",B)
    show("A \\ B",A,B)
    show("B \\ A",B,A)
    printf("symmetric difference: ")
    for (i in C) {
      if (!(i in A && i in B)) {
        printf("%s ",i)
      }
    }
    printf("\n")
    exit(0)
}
function load(str,arr,  i,n,temp) {
    n = split(str,temp,",")
    for (i=1; i<=n; i++) {
      arr[temp[i]]
      C[temp[i]]
    }
}
function show(str,a,b,  i) {
    printf("%s: ",str)
    for (i in a) {
      if (!(i in b)) {
        printf("%s ",i)
      }
    }
    printf("\n")
}
