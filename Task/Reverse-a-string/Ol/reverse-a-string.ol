(define (rev s)
   (runes->string (reverse (string->runes s))))

; testing:
(print (rev "Hello, λ!"))
; ==> !λ ,olleH
