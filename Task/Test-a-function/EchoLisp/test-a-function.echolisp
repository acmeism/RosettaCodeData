(assert (palindrome? "aba")) → #t
(assert (palindrome? "abbbca") "palindrome fail")
💥 error: palindrome fail : assertion failed : (palindrome? abbbca)

(check-expect (palindrome? "aba") #t) → #t
(check-expect (palindrome? "abcda") #f) → #t
(check-expect (palindrome? "abcda") #t)
😐 warning: #t : check failed : (palindrome? abcda) → #f
(assert (palindrome? "un roc lamina l animal cornu")) → #t
