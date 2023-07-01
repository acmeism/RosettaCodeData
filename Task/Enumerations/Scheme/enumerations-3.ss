(define-syntax test
  (syntax-rules ()
    ((_ e)
      (printf "~a --> ~s~%" 'e e))))

(printf "~%The 'foo' enum:~%")

(enum foo a (b 10) c (d 20) e (f 30) g)

(test a)
(test b)
(test c)
(test d)
(test e)
(test f)
(test g)
(test foo)
(test (assq 'd foo))
(test (assq 'm foo))

(printf "~%The 'bar' enum:~%")

(enum bar x y (z 99))

(test x)
(test y)
(test z)
(test bar)
