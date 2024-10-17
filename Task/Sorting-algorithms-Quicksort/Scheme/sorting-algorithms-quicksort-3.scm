;;;-------------------------------------------------------------------
;;;
;;; Quicksort in R7RS Scheme, working in-place on vectors (that is,
;;; arrays). I closely follow the "better quicksort algorithm"
;;; pseudocode, and thus the code is more "procedural" than
;;; "functional".
;;;
;;; I use a random pivot. If you can generate a random number quickly,
;;; this is a good method, but for this demonstration I have taken a
;;; fast linear congruential generator and made it brutally slow. It's
;;; just a demonstration. :)
;;;

(import (scheme base))
(import (scheme case-lambda))
(import (scheme write))

;;;-------------------------------------------------------------------
;;;
;;; Add "while" loops to the language.
;;;

(define-syntax while
  (syntax-rules ()
    ((_ pred? body ...)
     (let loop ()
       (when pred?
         (begin body ...)
         (loop))))))

;;;-------------------------------------------------------------------
;;;
;;; In-place quicksort.
;;;

(define vector-quicksort!
  (case-lambda

    ;; Use a default pivot selector.
    ((<? vec)
     ;; Random pivot.
     (vector-quicksort! (lambda (vec i-first i-last)
                          (vector-ref vec (randint i-first i-last)))
                        <? vec))

    ;; Specify a pivot selector.
    ((pivot-select <? vec)
     ;;
     ;; The recursion:
     ;;
     (let quicksort! ((i-first 0)
                      (i-last (- (vector-length vec) 1)))
       (let ((n (- i-last i-first -1)))
         (when (> n 1)
           (let* ((pivot (pivot-select vec i-first i-last)))
             (let ((left i-first)
                   (right i-last))
               (while (<= left right)
                 (while (< (vector-ref vec left) pivot)
                   (set! left (+ left 1)))
                 (while (> (vector-ref vec right) pivot)
                   (set! right (- right 1)))
                 (when (<= left right)
                   (let ((lft (vector-ref vec left))
                         (rgt (vector-ref vec right)))
                     (vector-set! vec left rgt)
                     (vector-set! vec right lft)
                     (set! left (+ left 1))
                     (set! right (- right 1)))))
               (quicksort! i-first right)
               (quicksort! left i-last)))))))))

;;;-------------------------------------------------------------------
;;;
;;; A simple linear congruential generator, attributed by
;;; https://en.wikipedia.org/w/index.php?title=Linear_congruential_generator&oldid=1083800601
;;; to glibc and GCC. No attempt has been made to optimize this code.
;;;

(define seed 1)
(define two**31 (expt 2 31))
(define (random-integer)
  (let* ((s0 seed)
         (s1 (truncate-remainder (+ (* 1103515245 s0) 12345)
                                 two**31)))
    (set! seed s1)
    s0))
(define randint
  (case-lambda
    ((n) (truncate-remainder (random-integer) n))
    ((i-first i-last) (+ i-first (randint (- i-last i-first -1))))))

;;;-------------------------------------------------------------------
;;;
;;; A demonstration of in-place vector quicksort.
;;;

(define vec1 (vector-copy #(60 53 100 72 19 67 14
                               31 4 1 5 9 2 6 5 3 5 8
                               28 9 95 22 67 55 20 41
                               42 29 20 74 39)))
(vector-quicksort! < vec1)
(write vec1)
(newline)

;;;-------------------------------------------------------------------
