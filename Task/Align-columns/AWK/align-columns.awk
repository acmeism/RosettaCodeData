# syntax: GAWK -f ALIGN_COLUMNS.AWK ALIGN_COLUMNS.TXT
BEGIN {
    colsep = " " # separator between columns
    report("raw data")
}
{   printf("%s\n",$0)
    arr[NR] = $0
    n = split($0,tmp_arr,"$")
    for (j=1; j<=n; j++) {
      width = max(width,length(tmp_arr[j]))
    }
}
END {
    report("left justified")
    report("right justified")
    report("center justified")
    exit(0)
}
function report(text,  diff,i,j,l,n,r,tmp_arr) {
    printf("\nreport: %s\n",text)
    for (i=1; i<=NR; i++) {
      n = split(arr[i],tmp_arr,"$")
      if (tmp_arr[n] == "") { n-- }
      for (j=1; j<=n; j++) {
        if (text ~ /^[Ll]/) { # left
          printf("%-*s%s",width,tmp_arr[j],colsep)
        }
        else if (text ~ /^[Rr]/) { # right
          printf("%*s%s",width,tmp_arr[j],colsep)
        }
        else if (text ~ /^[Cc]/) { # center
          diff = width - length(tmp_arr[j])
          l = r = int(diff / 2)
          if (diff != l + r) { r++ }
          printf("%*s%s%*s%s",l,"",tmp_arr[j],r,"",colsep)
        }
      }
      printf("\n")
    }
}
function max(x,y) { return((x > y) ? x : y) }
