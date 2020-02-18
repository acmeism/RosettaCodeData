# syntax: GAWK -f MAXIMUM_TRIANGLE_PATH_SUM.AWK filename(s)
{   printf("%s\n",$0)
    cols[FNR] = NF
    for (i=1; i<=NF; i++) {
      arr[FNR][i] = $i
    }
}
ENDFILE {
    for (row=FNR-1; row>0; row--) {
      for (col=1; col<=cols[row]; col++) {
        arr[row][col] += max(arr[row+1][col],arr[row+1][col+1])
      }
    }
    printf("%d using %s\n\n",arr[1][1],FILENAME)
    delete arr
    delete cols
}
END {
    exit(0)
}
function max(x,y) { return((x > y) ? x : y) }
