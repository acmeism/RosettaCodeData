# syntax: GAWK -f ABBREVIATIONS_AUTOMATIC.AWK ABBREVIATIONS_AUTOMATIC.TXT
{ dow_arr[NR] = $0 }
END {
    for (i=1; i<=NR; i++) {
      if (split(dow_arr[i],arr1,FS) != 7) {
        printf("NG %s\n",dow_arr[i])
        continue
      }
      col_width = 0
      for (j=1; j<=7; j++) {
        col_width = max(col_width,length(arr1[j]))
      }
      for (col=1; col<=col_width; col++) {
        delete arr2
        for (j=1; j<=7; j++) {
          arr2[toupper(substr(arr1[j],1,col))]
        }
        if (length(arr2) == 7) {
          break
        }
        if (col >= col_width) { # catches duplicate day names
          col = "NG"
          break
        }
      }
      printf("%2s %s\n",col,dow_arr[i])
    }
    exit(0)
}
function max(x,y) { return((x > y) ? x : y) }
