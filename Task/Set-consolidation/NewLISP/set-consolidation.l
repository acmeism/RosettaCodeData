(macro (reduce Func List (Init-Val nil))
  (apply
    Func
    (append (if (= nil Init-Val) '() (list Init-Val)) List)
    2))

(define (consol ss)
  (let (comb
          (lambda (cs s)
            (cond ((empty? s) cs)
                  ((empty? cs) (list s))
                  ((empty? (intersect s (first cs)))
                   (cons (first cs) (comb (rest cs) s)))
                  (true (consol (cons (union s (cs 0)) (rest cs)))))))
    (reduce comb ss '())))

(consol '((a b) (c d)))

((a b) (c d))

(consol '((a b) (b c)))

((b c a))

(consol '((a b) (c d) (d b)))

((c d b a))

(consol '((h i k) (a b) (c d) (d b) (f g h)))

((f g h i k) (c d b a))
