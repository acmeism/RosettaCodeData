# syntax: GAWK -f SUM_OF_ELEMENTS_BELOW_MAIN_DIAGONAL_OF_MATRIX.AWK
BEGIN {
    arr1[++n] = "1,3,7,8,10"
    arr1[++n] = "2,4,16,14,4"
    arr1[++n] = "3,1,9,18,11"
    arr1[++n] = "12,14,17,18,20"
    arr1[++n] = "7,1,3,9,5"
    for (i=1; i<=n; i++) {
      x = split(arr1[i],arr2,",")
      if (x != n) {
        printf("error: row %d has %d elements; S/B %d\n",i,x,n)
        errors++
        continue
      }
      for (j=1; j<i; j++) { # below main diagonal
        sum_b += arr2[j]
        cnt_b++
      }
      for (j=i+1; j<=n; j++) { # above main diagonal
        sum_a += arr2[j]
        cnt_a++
      }
      for (j=1; j<=i; j++) { # on main diagonal
        if (j == i) {
          sum_o += arr2[j]
          cnt_o++
        }
      }
    }
    if (errors > 0) { exit(1) }
    printf("%5g Sum of the %d elements below main diagonal\n",sum_b,cnt_b)
    printf("%5g Sum of the %d elements above main diagonal\n",sum_a,cnt_a)
    printf("%5g Sum of the %d elements on main diagonal\n",sum_o,cnt_o)
    printf("%5g Sum of the %d elements in the matrix\n",sum_b+sum_a+sum_o,cnt_b+cnt_a+cnt_o)
    exit(0)
}
