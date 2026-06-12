brd$[] = strchars "
┏━━━━━━━━━┓
┃    ·    ┃
┃   ● ●   ┃
┃  ● ● ●  ┃
┃ ● ● ● ● ┃
┃● ● ● ● ●┃
┗━━━━━━━━━┛"
proc solve &solution$ .
   solution$ = ""
   for pos = 1 to len brd$[]
      if brd$[pos] = "●"
         npegs += 1
         for dir in [ -13 -11 2 13 11 -2 ]
            if brd$[pos + dir] = "●" and brd$[pos + 2 * dir] = "·"
               brd$[pos] = "·"
               brd$[pos + dir] = "·"
               brd$[pos + 2 * dir] = "●"
               solve solution$
               brd$[pos] = "●"
               brd$[pos + dir] = "●"
               brd$[pos + 2 * dir] = "·"
               if solution$ <> ""
                  solution$ = strjoin brd$[] "" & solution$
                  return
               .
            .
         .
      .
   .
   if npegs = 1 : solution$ = strjoin brd$[] ""
.
solve solution$
print solution$
