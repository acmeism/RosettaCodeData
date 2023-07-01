(define (lexorder a b)
   (cond
      ((null? b) #false)
      ((null? a) #true)
      ((< (car a) (car b)) #true)
      ((> (car a) (car b)) #false)
      (else
         (lexorder (cdr a) (cdr b)))))

(print (lexorder '(1 2 3) '(1 2 3 4))) ; => true
(print (lexorder '(1 2 4) '(1 2 3)))   ; => false
(print (lexorder '(1 2 3) '(1 2)))     ; => false
(print (lexorder '(1 2 3) '(1 2 3)))   ; => false
(print (lexorder '(1 2 3) '(1 2 8)))   ; => true
