#lang slideshow
(define-syntax-rule (vector-neg-set! vec pos)
  (vector-set! vec pos (not (vector-ref vec pos))))

(define (make-doors)
  (define doors (make-vector 100 #f))
  (for ([i (in-range 100)])
    (for ([j (in-range i 100 (add1 i))])
      (vector-neg-set! doors j)))
  doors)

(displayln (list->string (for/list ([d (make-doors)])
                           (if d #\o #\-))))

(define (closed-door) (inset (filled-rectangle 4 20) 2))
(define (open-door) (inset (rectangle 4 20) 2))

(for/fold ([doors (rectangle 0 0)])
          ([open? (make-doors)])
  (hc-append doors (if open? (open-door) (closed-door))))
