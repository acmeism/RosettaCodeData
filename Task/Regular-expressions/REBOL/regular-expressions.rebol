REBOL [
	Title: "Regular Expression Matching"
	Author: oofoe
	Date: 2009-12-06
	URL: http://rosettacode.org/wiki/Regular_expression_matching
]

string: "This is a string."

; REBOL doesn't use a conventional Perl-compatible regular expression
; syntax. Instead, it uses a variant Parsing Expression Grammar with
; the 'parse' function. It's also not limited to just strings. You can
; define complex grammars that actually parse and execute program
; files.

; Here, I provide a rule to 'parse' that specifies searching through
; the string until "string." is found, then the end of the string. If
; the subject string satisfies the rule, the expression will be true.

if parse string [thru "string." end] [
	print "Subject ends with 'string.'"]

; For replacement, I take advantage of the ability to call arbitrary
; code when a pattern is matched -- everything in the parens will be
; executed when 'to " a "' is satisfied. This marks the current string
; location, then removes the offending word and inserts the replacement.

parse string [
	to " a " ; Jump to target.
	mark: (
		remove/part mark 3 ; Remove target.
		mark: insert mark " another " ; Insert replacement.
	)
	:mark ; Pick up where I left off.
]
print [crlf "Parse replacement:" string]

; For what it's worth, the above operation is more conveniently done
; with the 'replace' function:

replace string " another " " a " ; Change string back.
print [crlf "Replacement:" string]
