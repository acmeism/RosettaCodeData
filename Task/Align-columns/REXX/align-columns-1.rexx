/*REXX*/
z.1 = "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
z.2 = "are$delineated$by$a$single$'dollar'$character,$write$a$program"
z.3 = "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
z.4 = "column$are$separated$by$at$least$one$space."
z.5 = "Further,$allow$for$each$word$in$a$column$to$be$either$left$"
z.6 = "justified,$right$justified,$or$center$justified$within$its$column."

word. = ""
width. = 0
maxcol = 0
do row = 1 to 6
  line = z.row
  do col = 1 by 1 until length(line) = 0
    parse var line word.row.col "$" line
    if length(word.row.col) > width.col then width.col = length(word.row.col)
  end
  if col > maxcol then maxcol = col
end

say "align left:"
say
do row = 1 to 6
  out = ""
  do col = 1 to maxcol
    out = out || left(word.row.col,width.col+1)
  end
  say out
end
say
say "align right:"
say
do row = 1 to 6
  out = ""
  do col = 1 to maxcol
    out = out || right(word.row.col,width.col+1)
  end
  say out
end
say
say "align center:"
say
do row = 1 to 6
  out = ""
  do col = 1 to maxcol
    out = out || center(word.row.col,width.col+1)
  end
  say out
end
