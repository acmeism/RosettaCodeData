(de palindrome? (S)
   (= (setq S (chop S)) (reverse S)) )

(test T (palindrome? "racecar"))
(test NIL (palindrome? "ferrari"))
