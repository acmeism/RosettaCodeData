palindrome?: func [
    phrase [string!] "Potentially palindromatic prose."
    /case            "Case-sensitive comparison"
][  either case [
        phrase == reverse copy phrase
    ][  phrase  = reverse copy phrase]
]
inexact-palindrome?: func [
    phrase [string!] "Potentially palindromatic prose."
    /ignore ignored
][
    if palindrome?/case phrase [return true]
    unless ignored [
        ignored: charset " ^-.,-/"
    ]
    all [
        ;; Remove ignored characters
        phrase: copy phrase
        parse phrase [any[
            to ignored
            remove [some ignored]
        ] to end]
        palindrome? phrase
    ]
]

; Teeny Tiny Test Suite
assert: func [code][print [either do code ["  ok"]["FAIL"]  mold/flat code]]

print "Simple palindromes, with an exception for variety:"
foreach phrase ["z" "aha" "sees" "oofoe" "Deified"][
    assert compose [palindrome? (phrase)]]

print "Inexact palindromes:"
foreach phrase [
    "A man, a plan, a canal, Panama."
    "In girum imus nocte et consumimur igni"
    "Never odd or even"
][
    assert compose [inexact-palindrome? (phrase)]
]
