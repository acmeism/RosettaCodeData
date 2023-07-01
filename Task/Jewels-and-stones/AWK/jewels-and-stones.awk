# syntax: GAWK -f JEWELS_AND_STONES.AWK
BEGIN {
    printf("%d\n",count("aAAbbbb","aA"))
    printf("%d\n",count("ZZ","z"))
    exit(0)
}
function count(stone,jewel,  i,total) {
    for (i=1; i<length(stone); i++) {
      if (jewel ~ substr(stone,i,1)) {
        total++
      }
    }
    return(total)
}
