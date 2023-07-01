# syntax: GAWK -f SPINNING_ROD_ANIMATION_TEXT.AWK
@load "time"
BEGIN {
    while (1) {
      printf(" %s\r",substr("|/-\\",x++%4+1,1))
      sleep(.25)
    }
    exit(0)
}
