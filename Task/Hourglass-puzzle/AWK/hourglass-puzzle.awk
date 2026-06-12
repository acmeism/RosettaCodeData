# syntax: GAWK -f HOURGLASS_PUZZLE.AWK
BEGIN {
    limit = 100
    t4 = 0
    while (t4 < limit) {
      t7_left = 7 - t4 % 7
      if (t7_left == 9 - 4) {
        break
      }
      t4 += 4
    }
    if (t4 > limit) {
      printf("Unable to find an answer within %d iterations\n",limit)
      exit(1)
    }
    str = sprintf("Turn over both hour glasses at the same time and continue flipping them each " \
    "when they individually run down until the 4 hour glass is flipped %d times, " \
    "wherupon the 7 hour glass is immediately placed on its side with %d minutes " \
    "of sand in it. " \
    "You can measure 9 minutes by flipping the 4 hour glass once, then " \
    "flipping the remaining sand in the 7 hour glass when the 4 hour glass ends.",t4/4,t7_left)
    fold(str)
    exit(0)
}
function fold(rec,  chars_printed,indx,text) {
    line_length = 80
    while (1) {
      indx = match(rec," ")
      if (indx == 0) {
        printf("%s\n",rec)
        break
      }
      text = substr(rec,1,indx)
      printf("%s",text)
      rec = substr(rec,RSTART+1)
      chars_printed += length(text)
      if (chars_printed > line_length) {
        printf("\n")
        chars_printed = 0
      }
    }
}
