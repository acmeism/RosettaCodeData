REBOL [
	Title: "Retrieve Substring"
	URL: http://rosettacode.org/wiki/Substring#REBOL
]

s: "abcdefgh"  n: 2  m: 3  char: #"d"  chars: "cd"

; Note that REBOL uses base-1 indexing. Strings are series values,
; just like blocks or lists so I can use the same words to manipulate
; them. All these examples use the 'copy' function against the 's'
; string with a particular offset as needed.

; For the fragment "copy/part  skip s n - 1  m", read from right to
; left.  First you have 'm', which we ignore for now. Then evaluate
; 'n - 1' (makes 1), to adjust the offset. Then 'skip' jumps from the
; start of the string by that offset. 'copy' starts copying from the
; new start position and the '/part' refinement limits the copy by 'm'
; characters.

print ["Starting from n, length m:"
	copy/part  skip s n - 1  m]

; It may be helpful to see the expression with optional parenthesis:

print ["Starting from n, length m (parens):"
	(copy/part  (skip s (n - 1))  m)]

; This example is much simpler, so hopefully it's easier to see how
; the string start is position for the copy:

print ["Starting from n to end of string:"
	copy skip s n - 1]

print ["Whole string minus last character:"
	copy/part s (length? s) - 1]

print ["Starting from known character, length m:"
	copy/part  find s char  m]

print ["Starting from substring, length m:"
	copy/part  find s chars  m]
