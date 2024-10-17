(define (try-all) ;; The arguments are in (args) or $args.
  (let (cnt (length (filter true? $args)))
    (if (zero? cnt) nil cnt)))

(define (fizz)
  (define (say? n s) (if (= 0 (% i n)) (print s))) ;; Dynamic scoping.
  (for (i 1 21)
    (unless
      (try-all
        (say? 3 'fizz)
        (say? 5 'buzz)
        (say? 7 'boom)
        (say? 11 'crux))
      (print i))
    (println)))

(fizz)

1
2
fizz
4
buzz
fizz
boom
8
fizz
buzz
crux
fizz
13
boom
fizzbuzz
16
17
fizz
19
buzz
fizzboom
