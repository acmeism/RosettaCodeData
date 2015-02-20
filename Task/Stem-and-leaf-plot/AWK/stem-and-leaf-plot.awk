# syntax: GAWK -f STEM-AND-LEAF_PLOT.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    data = "12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36 29 31 " \
    "125 139 131 115 105 132 104 123 35 113 122 42 117 119 58 109 23 105 63 27 44 " \
    "105 99 41 128 121 116 125 32 61 37 127 29 113 121 58 114 126 53 114 96 25 " \
    "109 7 31 141 46 13 27 43 117 116 27 7 68 40 31 115 124 42 128 52 71 118 117 " \
    "38 27 106 33 117 116 111 40 119 47 105 57 122 109 124 115 43 120 43 27 27 18 " \
    "28 48 125 107 114 34 133 45 120 30 127 31 116 146"
    data_points = split(data,data_arr," ")
    for (i=1; i<=data_points; i++) {
      x = data_arr[i]
      stem = int(x / 10)
      leaf = x % 10
      if (i == 1) {
        lo = hi = stem
      }
      lo = min(lo,stem)
      hi = max(hi,stem)
      arr[stem][leaf]++
    }
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (i=lo; i<=hi; i++) {
      printf("%4d |",i)
      arr[i][""]
      for (j in arr[i]) {
        for (k=1; k<=arr[i][j]; k++) {
          printf(" %d",j)
          leaves_printed++
        }
      }
      printf("\n")
    }
    if (data_points == leaves_printed) {
      exit(0)
    }
    else {
      printf("error: %d data points != %d leaves printed\n",data_points,leaves_printed)
      exit(1)
    }
}
function max(x,y) { return((x > y) ? x : y) }
function min(x,y) { return((x < y) ? x : y) }
