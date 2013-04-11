REBOL [
	Title: "Align Columns"
	Author: oofoe
	Date: 2010-09-29
	URL: http://rosettacode.org/wiki/Align_columns
]

specimen: {Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.}

; Parse specimen into data grid.

data: copy []
foreach line parse specimen to-string lf [ ; Break into lines.
	append/only data parse line "$"        ; Break into columns.
]

; Compute independent widths for each column.

widths: copy []  insert/dup widths 0 length? data/1
foreach line data [
	forall line [
		i: index? line
		widths/:i: max widths/:i length? line/1
	]
]

pad: func [n /local x][x: copy ""  insert/dup x " " n  x]

; These formatting functions are passed as arguments to entable.

right: func [n s][rejoin [pad n - length? s  s]]

left: func [n s][rejoin [s  pad n - length? s]]

centre: func [n s /local h][
	h: round/down (n - length? s) / 2
	rejoin [pad h  s  pad n - h - length? s]
]

; Display data as table.

entable: func [data format] [
	foreach line data [
		forall line [
			prin rejoin [format  pick widths index? line  line/1  " "]
		]
		print ""
	]
]

; Format data table.

foreach i [left centre right] [
	print ["^/Align" i "...^/"]  entable data get i]
