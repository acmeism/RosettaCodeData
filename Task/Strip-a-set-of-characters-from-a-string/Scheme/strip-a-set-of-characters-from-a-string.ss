(import (scheme base)
        (scheme write)
        (only (srfi 13) string-delete)
        (only (srfi 14) ->char-set))

;; implementation in plain Scheme
(define (strip-chars str chars)
  (let ((char-list (string->list chars)))
    (define (do-strip str-list result)
      (cond ((null? str-list)
             (reverse result))
            ((member (car str-list) char-list char=?)
             (do-strip (cdr str-list) result))
            (else
              (do-strip (cdr str-list) (cons (car str-list) result)))))
    (list->string
      (do-strip (string->list str) '()))))

(display (strip-chars "She was a soul stripper. She took my heart!" "aei"))
(newline)

;; using functions in SRFI 13 and SRFI 14
(define (strip-chars2 str chars)
  (string-delete (->char-set chars) str))

(display (strip-chars2 "She was a soul stripper. She took my heart!" "aei"))
(newline)
