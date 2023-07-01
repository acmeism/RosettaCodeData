#lang racket/base
;; {trans|Kotlin}}

(define current-width (make-parameter 81))

(define current-height (make-parameter 5))

(define (Cantor_set (w (current-width)) (h (current-height)))
  (define lines (build-list h (λ (_) (make-bytes w (char->integer #\#)))))
  (define (cantor start len index)
    (let* ((seg (quotient len 3))
           (seg-start (+ start seg))
           (seg-end (+ seg-start seg)))
      (unless (zero? seg)
        (for* ((i (in-range index h))
               (j (in-range seg-start seg-end)))
          (bytes-set! (list-ref lines i) j (char->integer #\space)))
        (cantor start seg (add1 index))
        (cantor seg-end seg (add1 index)))))
  (cantor 0 w 1)
  lines)

(module+ main
  (for-each displayln (Cantor_set)))
