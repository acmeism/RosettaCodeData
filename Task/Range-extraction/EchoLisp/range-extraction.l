(define task '(0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 32 33 35 36 37 38 39))

;; 1- GROUPING
(define (group-range item acc)
(if
    (or (empty? acc) (!= (caar acc) (1- item)))
      (cons (cons item item) acc)
      (begin  (set-car! (car acc) item) acc)))

;; intermediate result
;; (foldl group-range () task)
;; → ((39 . 35) (33 . 27) (25 . 14) (12 . 11) (8 . 6) (4 . 4) (2 . 0))

;; 2- FORMATTING
(define (range->string range)
(let ((from (rest range)) (to (first range)))
		(cond
		((= from to) (format "%d " from))
		((= to (1+ from))  (format "%d, %d " from to))
		(else (format "%d-%d " from to)))))
		
;; 3 - FINAL
(string-join (map range->string  (reverse (foldl group-range () task))) ",")
    → "0-2 ,4 ,6-8 ,11, 12 ,14-25 ,27-33 ,35-39 "
