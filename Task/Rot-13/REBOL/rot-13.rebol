REBOL [
    Title: "Rot-13"
    Date: 2009-12-14
    Author: oofoe
    URL: http://rosettacode.org/wiki/Rot-13
]

; Test data has upper and lower case characters as well as characters
; that should not be transformed, like numbers, spaces and symbols.

text: "This is a 28-character test!"

print "Using cipher table:"

; I build a set of correspondence lists here. 'x' is the letters from
; A-Z, in both upper and lowercase form. Note that REBOL can iterate
; directly over the alphabetic character sequence in the for loop. 'y'
; is the cipher form, 'x' rotated by 26 characters (remember, I have
; the lower and uppercase forms together). 'r' holds the final result,
; built as I iterate across the 'text' string. I search for the
; current character in the plaintext list ('x'), if I find it, I get
; the corresponding character from the ciphertext list
; ('y'). Otherwise, I pass the character through untransformed, then
; return the final string.

rot-13: func [
	"Encrypt or decrypt rot-13 with tables."
	text [string!] "Text to en/decrypt."
	/local x y r i c
] [
	x: copy ""  for i #"a" #"z" 1 [append x rejoin [i  uppercase i]]
	y: rejoin [copy skip x 26  copy/part x 26]
	r: copy ""

	repeat i text [append r  either c: find/case x i [y/(index? c)][i]]
	r
]

; Note that I am setting the 'text' variable to the result of rot-13
; so I can reuse it again on the next call. The rot-13 algorithm is
; reversible, so I can just run it again without modification to decrypt.

print ["    Encrypted:"  text: rot-13 text]
print ["    Decrypted:"  text: rot-13 text]


print "Using parse:"

clamp: func [
	"Contain a value within two enclosing values. Wraps if necessary."
	x v y
][
	x: to-integer x  v: to-integer v  y: to-integer y
	case [v < x [y - v] v > y [v - y + x - 1] true v]
]

; I'm using REBOL's 'parse' word here. I set up character sets for
; upper and lower-case letters, then let parse walk across the
; text. It looks for matches to upper-case letters, then lower-case,
; then skips to the next one if it can't find either. If a matching
; character is found, it's mathematically incremented by 13 and
; clamped to the appropriate character range. parse changes the
; character in place in the string, hence this is a destructive
; operation.

rot-13: func [
	"Encrypt or decrypt rot-13 with parse."
	text [string!] "Text to en/decrypt. Note: Destructive!"
] [
	u: charset [#"A" - #"Z"]
	l: charset [#"a" - #"z"]

	parse text [some [
			i:                                          ; Current position.
			u (i/1: to-char clamp #"A" i/1 + 13 #"Z") | ; Upper case.
			l (i/1: to-char clamp #"a" i/1 + 13 #"z") | ; Lower case.
			skip]]                                      ; Ignore others.
	text
]

; As you see, I don't need to re-assign 'text' anymore.

print ["    Encrypted:" rot-13 text]
print ["    Decrypted:" rot-13 text]
