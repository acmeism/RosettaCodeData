#lang racket

(require racket/sandbox)

(define tests '([-2  2  1 "Normal"]
                [-2  2  0 "Zero increment"]
                [-2  2 -1 "Increments away from stop value"]
                [-2  2 10 "First increment is beyond stop value"]
                [2  -2  1 "Start more than stop: positive increment"]
                [2   2  1 "Start equal stop: positive increment"]
                [2   2 -1 "Start equal stop: negative increment"]
                [2   2  0 "Start equal stop: zero increment"]
                [0   0  0 "Start equal stop equal zero: zero increment"]))

(for ([test (in-list tests)])
  (match-define (list st ed inc desc) test)
  (printf "~a:\n  (in-range ~a ~a ~a) = ~a\n\n"
          desc st ed inc
          (with-handlers ([exn:fail:resource? (thunk* 'timeout)])
            (with-limits 1 #f
              (sequence->list (in-range st ed inc))))))
