;;
;; Before the permutation is completely formed,
;; check for validity.
;;
;; n at a time.
(define (permute n__permute seq__permute func__permute
          (chk__permute or) (built__permute '()))
  (when (or (null? built__permute) (chk__permute built__permute))
    (if (or (zero? n__permute) (null? seq__permute))
      (func__permute built__permute)
      (dotimes (i__permute (length seq__permute))
        (unless (zero? i__permute) (rotate seq__permute -1))
        (permute (- n__permute 1)
          (rest seq__permute)
          func__permute
          chk__permute
          (append built__permute (0 1 seq__permute)))))))

(time
(permute -1 '(4 6 8 0 5 9 2 -1 7 1 3) println (fn(xs) (= xs (sort (copy xs)))))
)

(-1 0 1 2 3 4 5 6 7 8 9)
78.125  [ milliseconds ]


(time
(permute -1 '(4 6 8 0 5 9 2  7 1 3) println (fn(xs) (= xs (sort (copy xs)))))
)

(0 1 2 3 4 5 6 7 8 9)
15.625  [ milliseconds ]
