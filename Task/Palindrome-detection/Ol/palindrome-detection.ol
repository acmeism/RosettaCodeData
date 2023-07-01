; simple case - only lowercase letters
(define (palindrome? str)
   (let ((l (string->runes str)))
      (equal? l (reverse l))))

(print (palindrome? "ingirumimusnocteetconsumimurigni"))
; ==> #true
(print (palindrome? "thisisnotapalindrome"))
; ==> #false


; complex case - with ignoring letter case and punctuation
(define (alpha? x)
   (<= #\a x #\z))
(define (lowercase x)
   (if (<= #\A x #\Z)
      (- x (- #\A #\a))
      x))

(define (palindrome? str)
   (let ((l (filter alpha? (map lowercase (string->runes str)))))
      (equal? l (reverse l))))

(print (palindrome? "A man, a plan, a cat, a ham, a yak, a yam, a hat, a canal-Panama!"))
; ==> #true
(print (palindrome? "This is not a palindrome"))
; ==> #false
