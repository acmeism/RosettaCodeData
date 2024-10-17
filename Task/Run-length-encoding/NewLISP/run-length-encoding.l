;; Since newLISP has dynamic scope, use a namespace or context
;; to avoid variable capture.
(context 'monotonic-slices)

(define (monotonic-slices:monotonic-slices lst (key-func or) (cmp =))
  (let (result '()  tmp '()  old-key 0  new-key 0)
    (dolist (x lst)
      (set 'new-key (key-func x))
      (cond ((empty? tmp) (push x tmp))
            ((cmp new-key old-key) (push x tmp))
            (true (push (reverse tmp) result) (set 'tmp (list x))))
      (set 'old-key new-key))
    (unless (empty? tmp) (push (reverse tmp) result))
    (reverse result)))

(context MAIN)

(monotonic-slices '(0 0 2 3 3 3 4 5 5 5 5) )

((0 0) (2) (3 3 3) (4) (5 5 5 5))


(define (compress str)
  (apply string (flat
    (map
      (fn (xs) (list (length xs) (first xs)))
      (monotonic-slices (explode str))))))

(compress
  "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW")

"12W1B12W3B24W1B14W"


(define (decompress str)
  (apply  ;; Use for fold or reduce.
    (fn (built a b) (push (dup (b 0) (int (join a))) built -1))
    (cons ""
      (monotonic-slices
        (explode str)
        (fn (c) (<= "0" c "9"))))
    3))

(decompress "12W1B12W3B24W1B14W")

"WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
