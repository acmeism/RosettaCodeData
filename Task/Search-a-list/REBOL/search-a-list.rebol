REBOL [
	Title: "List Indexing"
	URL: http://rosettacode.org/wiki/Index_in_a_list
]

locate: func [
	"Find the index of a string (needle) in string collection (haystack)."
	haystack [series!] "List of values to search."
	needle [string!] "String to find in value list."
	/largest "Return the largest index if more than one needle."
	/local i
][
	i: either largest [
		find/reverse tail haystack needle][find haystack needle]
	either i [return index? i][
		throw reform [needle "is not in haystack."]
	]
]

; Note that REBOL uses 1-base lists instead of 0-based like most
; computer languages. Therefore, the index provided will be one
; higher than other results on this page.

haystack: parse "Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo" none

print "Search for first occurance:"
foreach needle ["Washington" "Bush"] [
	print catch [
		reform [needle "=>" locate haystack needle]
	]
]

print [crlf "Search for last occurance:"]
foreach needle ["Washington" "Bush"] [
	print catch [
		reform [needle "=>" locate/largest haystack needle]
	]
]
