(define (palindrome? s)
    (setq r s)
    (reverse r) ; Reverse is destructive.
    (= s r))

;; Make ‘reverse’ non-destructive and avoid a global variable
(define (palindrome? s)
    (= s (reverse (copy s))))
