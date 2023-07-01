Red [
  Title: "Align Columns"
  Original-Author: oofoe
]

text: {Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.}

; Parse specimen into data grid.

data: copy []
foreach line split text lf [
  append/only data split line "$"
]

; Compute independent widths for each column.

widths: copy []
foreach line data [
  forall line [
    i: index? line
    if i > length? widths [append widths 0]
    widths/:i: max widths/:i length? line/1
  ]
]

pad: function [n] [x: copy "" insert/dup x " " n x]

; These formatting functions are passed as arguments to entable.

right: func [n s][rejoin [pad n - length? s s]]

left: func [n s][rejoin [s pad n - length? s]]

centre: function [n s] [
  d: n - length? s
  h: round/down d / 2
  rejoin [pad h s pad d - h]
]

; Display data as table.

entable: func [data format] [
  foreach line data [
    forall line [
      prin rejoin [format pick widths index? line line/1 " "]
    ]
    print ""
  ]
]

; Format data table.

foreach i [left centre right] [
  print [newline "Align" i "..." newline]  entable data get i]
