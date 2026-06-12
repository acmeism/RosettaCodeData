# syntax: GAWK -f RAINBOW.AWK
# 8 colors are used: gray red green yellow blue magenta cyan white
BEGIN {
    n = split("RAINBOW,RosettaCode.org",arr,",")
    for (i=1; i<=n; i++) {
      for (j=1; j<=length(arr[i]); j++) {
        color = 90 + j % 8
        printf("\033[%dm%s",color,substr(arr[i],j,1))
      }
      printf("\n\n")
    }
    exit(0)
}
