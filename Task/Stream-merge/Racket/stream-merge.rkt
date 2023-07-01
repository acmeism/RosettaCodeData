;; This module produces a sequence that merges streams in order (by <)
#lang racket/base
(require racket/stream)

(define-values (tl-first tl-rest tl-empty?)
  (values stream-first stream-rest stream-empty?))

(define-struct merged-stream (< ss v ss′)
  #:mutable ; sadly, so we don't have to redo potentially expensive <
  #:methods gen:stream
  [(define (stream-empty? S)
     ;; andmap defined to be true when ss is null
     (andmap tl-empty? (merged-stream-ss S)))

   (define (cache-next-head S)
     (unless (box? (merged-stream-v S))
       (define < (merged-stream-< S))
       (define ss (merged-stream-ss S))
       (define-values (best-f best-i)
         (for/fold ((F #f) (I 0)) ((s (in-list ss)) (i (in-naturals)))
           (if (tl-empty? s) (values F I)
               (let ((f (tl-first s)))
                 (if (or (not F) (< f (unbox F))) (values (box f) i) (values F I))))))
       (set-merged-stream-v! S best-f)
       (define ss′ (for/list ((s ss) (i (in-naturals)) #:unless (tl-empty? s))
                     (if (= i best-i) (tl-rest s) s)))
       (set-merged-stream-ss′! S ss′))
     S)

   (define (stream-first S)
     (cache-next-head S)
     (unbox (merged-stream-v S)))

   (define (stream-rest S)
     (cache-next-head S)
     (struct-copy merged-stream S [ss (merged-stream-ss′ S)] [v #f]))])

(define ((merge-sequences <) . sqs)
  (let ((strms (map sequence->stream sqs)))
    (merged-stream < strms #f #f)))

;; ---------------------------------------------------------------------------------------------------
(module+ main
  (require racket/string)
  ;; there are file streams and all sorts of other streams -- we can even read lines from strings
  (for ((l ((merge-sequences string<?)
            (in-lines (open-input-string "aardvark
dog
fox"))
            (in-list (string-split "cat donkey elephant"))
            (in-port read (open-input-string #<<<
"boy"
"emu"
"monkey"
<
                                             )))))
    (displayln l)))

;; ---------------------------------------------------------------------------------------------------
(module+ test
  (require rackunit)
  (define merge-sequences/< (merge-sequences <))

  (check-equal?
   (for/list ((i (in-stream (merge-sequences/< (in-list '(1 3 5)))))) i)
   '(1 3 5))
  ;; in-stream (and in-list) is optional (but may increase performance)
  (check-equal? (for/list ((i (merge-sequences/<))) i) null)
  (check-equal? (for/list ((i (merge-sequences/< '(1 3 5) '(2 4 6)))) i) '(1 2 3 4 5 6))
  (check-equal? (for/list ((i (merge-sequences/< '(1 3 5) '(2 4 6 7 8 9 10)))) i)
                '(1 2 3 4 5 6 7 8 9 10))
  (check-equal? (for/list ((i (merge-sequences/< '(2 4 6 7 8 9 10) '(1 3 5)))) i)
                '(1 2 3 4 5 6 7 8 9 10)))
