REBOL [
	Title: "Is Numeric?"
	Author: oofoe
	Date: 2009-12-04
	URL: http://rosettacode.org/wiki/IsNumeric
]

; Built-in.

numeric?: func [x][not error? try [to-decimal x]]

; Parse dialect for numbers.

sign:   [0 1 "-"]
digit:  charset "0123456789"
int:    [some digit]
float:  [int "." int]
number: [
	sign float ["e" | "E"] sign int |
	sign int ["e" | "E"] sign int |
	sign float |
	sign int
]

pnumeric?: func [x][parse x number]

; Test cases.

cases: parse {
   10 -99
   10.43 -12.04
   1e99 1.0e10 -10e3 -9.12e7 2e-4 -3.4E-5
   3phase  Garkenhammer  e  n3v3r  phase3
} none
foreach x cases [print [x  numeric? x  pnumeric? x]]
