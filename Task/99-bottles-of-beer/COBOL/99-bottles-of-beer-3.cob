program-id. ninety-nine.
data division.
working-storage section.
01  cnt       pic 99.

procedure division.

  perform varying cnt from 99 by -1 until cnt < 1
    display cnt " bottles of beer on the wall"
    display cnt " bottles of beer"
    display "Take one down, pass it around"
    subtract 1 from cnt
    display cnt " bottles of beer on the wall"
    add 1 to cnt
    display space
  end-perform.
