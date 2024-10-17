(define (make-list separator)
  (define counter 1)

  (define (make-item item)
    (let ((result (string-append (number->string counter) separator item "\n")))
      (set! counter (+ counter 1))
      result))

  (string-append (make-item "first") (make-item "second") (make-item "third")))

(display (make-list ". "))
