(import (srfi 64))
(test-begin "palindrome-tests")
(test-assert (palindrome? "ingirumimusnocteetconsumimurigni"))
(test-assert (not (palindrome? "This is not a palindrome")))
(test-equal #t (palindrome? "ingirumimusnocteetconsumimurigni")) ; another of several test functions
(test-end)
