#lang racket

(define memos (make-hash))
(define (ways-to-make-change cents coins)
  (cond [(or (empty? coins) (negative? cents)) 0]
        [(zero? cents) 1]
        [else (define (answerer-for-new-arguments)
                (+ (ways-to-make-change cents (rest coins))
                   (ways-to-make-change (- cents (first coins)) coins)))
              (hash-ref! memos (cons cents coins) answerer-for-new-arguments)]))

(time (ways-to-make-change 100 '(25 10 5 1)))
(time (ways-to-make-change 100000 '(100 50 25 10 5 1)))
(time (ways-to-make-change 1000000 '(200 100 50 20 10 5 2 1)))

#| Times in milliseconds, and results:

     cpu time: 1 real time: 1 gc time: 0
     242

     cpu time: 524 real time: 553 gc time: 163
     13398445413854501

     cpu time: 20223 real time: 20673 gc time: 10233
     99341140660285639188927260001 |#
