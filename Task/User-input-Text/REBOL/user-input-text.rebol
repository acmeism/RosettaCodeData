REBOL [
	Title: "Textual User Input"
	URL: http://rosettacode.org/wiki/User_Input_-_text
]

s: n: ""

; Because I have several things to check for, I've made a function to
; handle it. Note the question mark in the function name, this convention
; is often used in Forth to indicate test of some sort.

valid?: func [s n][
	error? try [n: to-integer n] ; Ignore error if conversion fails.
	all [0 < length? s  75000 = n]]

; I don't want to give up until I've gotten something useful, so I
; loop until the user enters valid data.

while [not valid? s n][
	print "Please enter a string, and the number 75000:"
	s: ask "string: "
	n: ask "number: "
]

; It always pays to be polite...

print rejoin [ "Thank you. Your string was '" s "'."]
