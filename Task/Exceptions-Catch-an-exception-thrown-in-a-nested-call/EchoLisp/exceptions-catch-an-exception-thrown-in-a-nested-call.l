(define (foo)
  (for ((i 2))
    (try
    (bar i)
    (catch (id message)
      (if (= id 'U0)
         (writeln message 'catched)
         (error id "not catched"))))))

(define (bar i)
    (baz i))

(define (baz i)
    (if (= i 0)
        (throw 'U0 "U0 raised")
        (throw 'U1 "U1 raised")))


(foo) →
    "U0 raised"     catched
    👓 error: U1 not catched
