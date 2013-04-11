REBOL [
	Title: "12x12 Multiplication Table"
	Author: oofoe
	Date: 2009-12-26
	URL: http://rosettacode.org/wiki/Print_a_Multiplication_Table
]

size: 12

; Because of REBOL's GUI focus, it doesn't really do pictured output,
; so I roll my own. See Formatted_Numeric_Output for more
; comprehensive version:

pad: func [pad n][
    n: to-string n
    insert/dup n " " (pad - length? n)
    n
]
p3: func [v][pad 3 v]  ; A shortcut, I hate to type...

--: has [x][repeat x size + 1 [prin "+---"]  print "+"]  ; Special chars OK.

.row: func [label y /local row x][
	row: reduce ["|" label "|"]
	repeat x size [append row reduce [either x < y ["   "][p3 x * y] "|"]]
	print rejoin row
]

--  .row " x " 1  --  repeat y size [.row  p3 y  y]  --

print rejoin [ crlf  "What about "  size: 5  "?"  crlf ]
--  .row " x " 1  --  repeat y size [.row  p3 y  y]  --

print rejoin [ crlf  "How about "  size: 20  "?"  crlf ]
--  .row " x " 1  --  repeat y size [.row  p3 y  y]  --
