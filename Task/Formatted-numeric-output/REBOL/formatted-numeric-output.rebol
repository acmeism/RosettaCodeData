REBOL [
	Title: "Formatted Numeric Output"
	URL: http://rosettacode.org/wiki/Formatted_Numeric_Output
]

; REBOL has no built-in facilities for printing pictured output.
; However, it's not too hard to cook something up using the
; string manipulation facilities.

zeropad: func [
	"Pad number with zeros or spaces. Works on entire number."
	pad "Number of characters to pad to."
	n "Number to pad."
	/space "Pad with spaces instead."
	/local nn c s
][
	n: to-string n  c: " "  s: ""

	if not space [
		c: "0"
		if #"-" = n/1 [pad: pad - 1  n: copy skip n 1  s: "-"]
	]

        insert/dup n c (pad - length? n)
	insert n s
    n
]

; These tests replicate the C example output.

print [zeropad/space 9 negate 7.125]
print [zeropad/space 9 7.125]
print 7.125
print [zeropad 9 negate 7.125]
print [zeropad 9 7.125]
print 7.125
