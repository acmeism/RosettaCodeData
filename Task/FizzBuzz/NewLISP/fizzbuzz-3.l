(define (m-prime-gen)
  (fn ( , n)  ;; Unused parameter n is our local variable.
    ;; Self-modifying code.
    (until (= 1 (length (factor (setf n (++ 2))))))
    n))

(define (try-all) ;; The arguments are in (args) or $args.
  (let (cnt (length (filter true? $args)))
    (if (zero? cnt) nil cnt)))

(define (fizz)
  (define (say? n s) (if (= 0 (% i n)) (print s))) ;; Dynamic scoping.
  (for (i 1 21)
    (let (p (m-prime-gen))
      (unless
        (try-all
          (say? (p) 'fizz)
          (say? (p) 'buzz)
          (say? (p) 'boom)
          (say? (p) 'crux)
          (say? (p) 'ZAP))
        (print i))
      (println))))

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
ZAP
boom
fizzbuzz
16
17
fizz
19
buzz
fizzboom
