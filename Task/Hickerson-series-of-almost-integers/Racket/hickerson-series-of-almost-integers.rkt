#lang racket
(require math/bigfloat)

(define (hickerson n)
 (bf/ (bffactorial n)
      2.bf
      (bfexpt (bflog 2.bf) (bf (+ n 1)))))

(for ([n (in-range 18)])
  (define hickerson-n (hickerson n))
  (define first-decimal
    (bigfloat->integer (bftruncate (bf* 10.bf (bffrac hickerson-n)))))
  (define almost-integer (if (or (= first-decimal 0) (= first-decimal 9))
                           "is Nearly integer"
                           "is not Nearly integer!"))
  (printf "~a: ~a ~a\n"
          (~r n #:min-width 2)
          (bigfloat->string hickerson-n)
          almost-integer))
