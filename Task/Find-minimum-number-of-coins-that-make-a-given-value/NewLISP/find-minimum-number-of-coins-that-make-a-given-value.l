(define (ch n (avail '(200 100 50 20 10 5 2 1)))
  (cond ((zero? n) '())
        ((< n (avail 0)) (ch n (1 avail)))
        ((cons (avail 0) (ch (- n (avail 0)) avail)))))

(ch 988)
