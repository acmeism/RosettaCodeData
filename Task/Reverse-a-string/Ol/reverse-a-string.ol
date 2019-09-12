(define (rev s)
   (runes->string (reverse (string->runes s))))

; testing:
(print (rev "as⃝df̅"))
; ==> ̅fd⃝sa
