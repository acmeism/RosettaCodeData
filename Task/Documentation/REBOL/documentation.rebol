REBOL [
    Title: "Documentation"
    Date: 2009-12-14
    Author: oofoe
    URL: http://rosettacode.org/wiki/Documentation
	Purpose: {To demonstrate documentation of REBOL pograms.}
]

; Notice the fields in the program header. The header is required for
; valid REBOL programs, although the fields don't have to be filled
; in. Standard fields are defined (see 'system/script/header'), but
; I can also define other fields as I like and they'll be available
; there.

; This is a comment. The semicolon can be inserted anywhere outside of
; a string and will escape to end of line. See the inline comments
; below.

; Functions can have a documentation string as the first part of the
; argument definition block. Each argument can specify what types it
; will accept as well as a description. All typing/documentation
; entries are optional. Notice that local variables can be documented
; as well.

sum: func [
	"Add numbers in block."
	data [block! list!] "List of numbers to add together."
	/average "Calculate average instead of sum."
	/local
	i "Iteration variable."
	x "Variable to hold results."
] [
	x: 0  repeat i data [x: x + i]
	either average [x / length? data][x] ; Functions return last result.
]

print [sum [1 2 3 4 5 6] crlf  sum/average [7 8 9 10] crlf]

; The help message is constructed from the public information about
; the function. Internal variable information isn't shown.

help sum  print ""

; The source command provides the source to any user functions,
; reconstructing the documentation strings if they're provided:

source sum  print ""

; This is an object, describing a person, whose name is Bob.

bob: make object! [
	name: "Bob Sorkopath"
	age: 24
	hi: func ["Say hello."][print "Hello!"]
]

; I can use the 'help' word to get a list of the fields of the object

help bob  print ""

; If I want see the documentation or source for 'bob/hi', I have to
; get a little tricky to get it from the object's namespace:

x: get in bob 'hi  help x  print ""

probe get in bob 'hi
