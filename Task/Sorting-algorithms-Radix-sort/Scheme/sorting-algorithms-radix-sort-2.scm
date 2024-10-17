;;; An illustrative implementation of the radix-10 example at
;;; https://en.wikipedia.org/w/index.php?title=Radix_sort&oldid=1070890278#Least_significant_digit

(cond-expand
  (r7rs)
  (chicken (import (r7rs))))

(import (scheme base))
(import (scheme write))

(define (sort-by-decimal-digit data power-of-10)
  (define bins (make-vector 10 '()))
  (do ((i (- (vector-length data) 1) (- i 1)))
      ((= i -1))
    (let* ((element (vector-ref data i))
           (digit (truncate-remainder
                   (truncate-quotient element power-of-10)
                   10)))
      (vector-set! bins digit
                   (cons element (vector-ref bins digit)))))
  (let ((non-zero-found
         (let loop ((i 1))
           (cond ((= i (vector-length bins)) #f)
                 ((pair? (vector-ref bins i)) #t)
                 (else (loop (+ i 1)))))))
    (when non-zero-found
      (let ((i 0))
        (do ((j 0 (+ j 1)))
            ((= j (vector-length bins)))
          (do ((p (vector-ref bins j) (cdr p)))
              ((null? p))
            (vector-set! data i (car p))
            (set! i (+ i 1))))))
    (not non-zero-found)))

(define (radix-sort data)
  (define offset 0)

  (do ((i 0 (+ i 1)))
      ((<= (vector-length data) i))
    (let ((x (vector-ref data i)))
      (when (negative? x)
        (set! offset (max offset (- x))))))

  (do ((i 0 (+ i 1)))
      ((= i (vector-length data)))
    (vector-set! data i (+ (vector-ref data i) offset)))

  (let loop ((power-of-10 1))
    (let ((done (sort-by-decimal-digit data power-of-10)))
      (unless done
        (loop (* 10 power-of-10)))))

  (do ((i 0 (+ i 1)))
      ((= i (vector-length data)))
    (let ((x (vector-ref data i)))
      (vector-set! data i (- (vector-ref data i) offset)))))

(define data (vector-copy #(170 45 75 90 2 802 2 66)))
(write data)
(newline)
(radix-sort data)
(write data)
(newline)

(newline)
(set! data (vector-copy #(170 -45 75 -90 2 -802 2 -66)))
(write data)
(newline)
(radix-sort data)
(write data)
(newline)
