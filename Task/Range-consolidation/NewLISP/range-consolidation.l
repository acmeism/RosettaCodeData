(define (norm range) (sort range))

(define (overlap? a b) (>= (a 1) (b 0)))

(define (combine)
  (list ($args 0 0) (max ($args 1 1) ($args 0 1))))

(define (foo ranges)
  (set 'ranges (map norm ranges))
  (set 'ranges (sort ranges))
  (let (accum '()  item)
    (dolist (r ranges)
      (set 'item (cond ((empty? accum) r)
                       ((overlap? (accum 0) r)
                        (combine (pop accum) r))
                       (true r)))
      (push item accum))
    (reverse accum)))


(foo '((1.1 2.2)))
((1.1 2.2))

(foo '((6.1 7.2) (7.2 8.3)))
((6.1 8.300000000000001))

(foo '((4 3) (2 1)))
((1 2) (3 4))

(foo '((4 3) (2 1) (-1 -2) (3.9 10)))
((-2 -1) (1 2) (3 10))

(foo '((1 3) (-6 -1) (-4 -5) (8 2) (-6 -6)))
((-6 -1) (1 8))
