# syntax: GAWK -f STANDARD_DEVIATION.AWK
BEGIN {
    n = split("2,4,4,4,5,5,7,9",arr,",")
    for (i=1; i<=n; i++) {
      temp[i] = arr[i]
      printf("%g %g\n",arr[i],stdev(temp))
    }
    exit(0)
}
function stdev(arr,  i,n,s1,s2,variance,x) {
    for (i in arr) {
      n++
      x = arr[i]
      s1 += x ^ 2
      s2 += x
    }
    variance = ((n * s1) - (s2 ^ 2)) / (n ^ 2)
    return(sqrt(variance))
}
