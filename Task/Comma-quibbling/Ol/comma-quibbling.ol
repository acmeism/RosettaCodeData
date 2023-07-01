(define (quibble . args)
   (display "{")
   (let loop ((args args))
      (unless (null? args) (begin
         (display (car args))
         (cond
            ((= 1 (length args)) #t)
            ((= 2 (length args))
               (display " and "))
            (else
               (display ", ")))
         (loop (cdr args)))))
   (print "}"))

; testing =>
(quibble)
(quibble "ABC")
(quibble "ABC" "DEF")
(quibble "ABC" "DEF" "G" "H")
