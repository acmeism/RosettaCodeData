(import (associative-arrays))

;; Because the task calls for ‘arrays’, I start with actual arrays
;; rather than lists.
(define array1 (vector "a" "b" "c" "d"))
(define array2 (vector 1 2 3 4))

(define (silly-hashfunc s)
  (define h 1234)
  (do ((i 0 (+ i 1)))
      ((= i (string-length s)))
    (set! h (+ h (char->integer (string-ref s i)))))
  (sqrt (/ (* h 101) 9.80665)))

;; Here is the making of the associative array:
(define dictionary (assoc-array silly-hashfunc))
(vector-for-each (lambda (key data)
                   (set! dictionary
                     (assoc-array-set dictionary key data)))
                 array1 array2)

(display "Looking up \"b\" and \"d\": ")
(write (assoc-array-ref dictionary "b"))
(display " ")
(write (assoc-array-ref dictionary "d"))
(newline)

;; Output:
;;
;;   Looking up "b" and "d": 2 4
;;
