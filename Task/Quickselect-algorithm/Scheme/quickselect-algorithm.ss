;;
;; Quickselect with random pivot.
;;
;; Such a pivot provides O(n) worst-case *expected* time.
;;
;; One can get true O(n) time by using "median of medians" to choose
;; the pivot, but quickselect with a median of medians pivot is a
;; complicated algorithm. See
;; https://en.wikipedia.org/w/index.php?title=Median_of_medians&oldid=1082505985
;;
;; Random pivot has the further advantage that it does not require any
;; comparisons of array elements.
;;
;; By the way, SRFI-132 specifies that vector-select! have O(n)
;; running time, and yet the reference implementation (as of 21 May
;; 2022) uses random pivot. I am pretty sure you cannot count on an
;; implementation having "true" O(n) behavior.
;;

(import (scheme base))
(import (scheme case-lambda))
(import (scheme write))
(import (only (scheme process-context) exit))
(import (only (srfi 27) random-integer))

(define (vector-swap! vec i j)
  (let ((xi (vector-ref vec i))
        (xj (vector-ref vec j)))
    (vector-set! vec i xj)
    (vector-set! vec j xi)))

(define (search-right <? pivot i j vec)
  (let loop ((i i))
    (cond ((= i j) i)
          ((<? pivot (vector-ref vec i)) i)
          (else (loop (+ i 1))))))

(define (search-left <? pivot i j vec)
  (let loop ((j j))
    (cond ((= i j) j)
          ((<? (vector-ref vec j) pivot) j)
          (else (loop (- j 1))))))

(define (partition <? pivot i-first i-last vec)
  ;; Partition a subvector into two halves: one with elements less
  ;; than or equal to a pivot, the other with elements greater than or
  ;; equal to a pivot. Returns an index where anything less than the
  ;; pivot is to the left of the index, and anything greater than the
  ;; pivot is either at the index or to its right. The implementation
  ;; is tail-recursive.
  (let loop ((i (- i-first 1))
             (j (+ i-last 1)))
    (if (= i j)
        i
        (let ((i (search-right <? pivot (+ i 1) j vec)))
          (if (= i j)
              i
              (let ((j (search-left <? pivot i (- j 1) vec)))
                (vector-swap! vec i j)
                (loop i j)))))))

(define (partition-around-random-pivot <? i-first i-last vec)
  (let* ((i-pivot (+ i-first (random-integer (- i-last i-first -1))))
         (pivot (vector-ref vec i-pivot)))

    ;; Move the last element to where the pivot had been. Perhaps the
    ;; pivot was already the last element, of course. In any case, we
    ;; shall partition only from I_first to I_last - 1.
    (vector-set! vec i-pivot (vector-ref vec i-last))

    ;; Partition the array in the range I_first..I_last - 1, leaving
    ;; out the last element (which now can be considered garbage).
    (let ((i-final (partition <? pivot i-first (- i-last 1) vec)))

      ;; Now everything that is less than the pivot is to the left of
      ;; I_final.

      ;; Put the pivot at I_final, moving the element that had been
      ;; there to the end. If I_final = I_last, then this element is
      ;; actually garbage and will be overwritten with the pivot,
      ;; which turns out to be the greatest element. Otherwise, the
      ;; moved element is not less than the pivot and so the
      ;; partitioning is preserved.
      (vector-set! vec i-last (vector-ref vec i-final))
      (vector-set! vec i-final pivot)

      ;; Return i-final, the final position of the pivot element.
      i-final)))

(define quickselect!
  (case-lambda

    ((<? vec k)
     ;; Select the (k+1)st least element of vec.
     (quickselect! <? 0 (- (vector-length vec) 1) vec k))

    ((<? i-first i-last vec k)
     ;; Select the (k+1)st least element of vec[i-first..i-last].
     (unless (and (<= 0 k) (<= k (- i-last i-first)))
       ;; Here you more likely want to raise an exception, but how to
       ;; do so is not specified in R7RS small. (It *is* specified in
       ;; R6RS, but R6RS features are widely unsupported by Schemes.)
       (display "out of range" (current-error-port))
       (exit 1))
     (let ((k (+ k i-first)))           ; Adjust k for index range.
       (let loop ((i-first i-first)
                  (i-last i-last))
         (if (= i-first i-last)
             (vector-ref vec i-first)
             (let ((i-final (partition-around-random-pivot
                             <? i-first i-last vec)))
               ;; Compare i-final and k, to see what to do next.
               (cond ((< i-final k) (loop (+ i-final 1) i-last))
                     ((< k i-final) (loop i-first (- i-final 1)))
                     (else (vector-ref vec i-final))))))))))

(define (print-kth <? k numbers-vector)
  (let* ((vec (vector-copy numbers-vector))
         (elem (quickselect! <? vec (- k 1))))
    (display " ")
    (display elem)))

(define example-numbers #(9 8 7 6 5 0 1 2 3 4))

(display "With < as order predicate: ")
(do ((k 1 (+ k 1)))
    ((= k 11))
  (print-kth < k example-numbers))
(newline)
(display "With > as order predicate: ")
(do ((k 1 (+ k 1)))
    ((= k 11))
  (print-kth > k example-numbers))
(newline)
