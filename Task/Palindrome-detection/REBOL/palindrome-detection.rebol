REBOL [
    Title: "Palindrome Recognizer"
    URL: http://rosettacode.org/wiki/Palindrome
]

; In order to compete with all the one-liners, the operation is
; compressed: parens force left hand side to evaluate first, where I
; copy the phrase, then uppercase it and assign it to 'p'. Now the
; right hand side is evaluated: p is copied, then reversed in place;
; the comparison is made and implicitely returned.

palindrome?: func [
	phrase [string!] "Potentially palindromatic prose."
	/local p
][(p: uppercase copy phrase) = reverse copy p]

; Teeny Tiny Test Suite

assert: func [code][print [either do code ["  ok"]["FAIL"]  mold code]]

print "Simple palindromes, with an exception for variety:"
repeat phrase ["z" "aha" "sees" "oofoe" "Deified"][
	assert compose [palindrome? (phrase)]]

print [crlf "According to the problem statement, these should fail:"]
assert [palindrome? "A man, a plan, a canal, Panama."] ; Punctuation not ignored.
assert [palindrome? "In girum imus nocte et consumimur igni"] ; Spaces not removed.

; I know we're doing palindromes, not alliteration, but who could resist...?
