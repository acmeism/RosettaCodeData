# syntax: GAWK -f DRAW_A_CLOCK.AWK [-v xc="*"]
BEGIN {
#   clearscreen_cmd = "clear" ; sleep_cmd = "sleep 1s" # Unix
    clearscreen_cmd = "CLS" ; sleep_cmd = "TIMEOUT /T 1 >NUL" # MS-Windows
    clock_build_digits()
    while (1) {
      now = strftime("%H:%M:%S")
      t[1] = substr(now,1,1)
      t[2] = substr(now,2,1)
      t[3] = 10
      t[4] = substr(now,4,1)
      t[5] = substr(now,5,1)
      t[6] = 10
      t[7] = substr(now,7,1)
      t[8] = substr(now,8,1)
      if (prev_now != now) {
        system(clearscreen_cmd)
        for (v=1; v<=8; v++) {
          printf("\t")
          for (h=1; h<=8; h++) {
            printf("%-8s",a[t[h],v])
          }
          printf("\n")
        }
        prev_now = now
      }
      system(sleep_cmd)
    }
    exit(0)
}
function clock_build_digits(  arr,i,j,x,y) {
    arr[1] = " 0000     1    2222   3333      4  555555  6666   777777 8888   9999         "
    arr[2] = "0    0   11   2    2 3    3    44  5      6      7     78    8 9    9        "
    arr[3] = "0   00  1 1        2      3   4 4  5      6           7 8    8 9    9   ::   "
    arr[4] = "0  0 0    1       2    333   4  4  555555 66666      7   8888  9    9   ::   "
    arr[5] = "0 0  0    1     22        3 444444      5 6    6    7   8    8  99999        "
    arr[6] = "00   0    1    2          3     4       5 6    6   7    8    8      9   ::   "
    arr[7] = "0    0    1   2      3    3     4  5    5 6    6  7     8    8      9   ::   "
    arr[8] = " 0000  1111111222222  3333      4   5555   6666   7      8888   9999         "
    for (i=1; i<=8; i++) {
      if (xc != "") {
        gsub(/[0-9:]/,substr(xc,1,1),arr[i]) # change "0-9" and ":" to substitution character
      }
      y++
      x = -1
      for (j=1; j<=77; j=j+7) {
        a[++x,y] = substr(arr[i],j,7)
      }
    }
}
