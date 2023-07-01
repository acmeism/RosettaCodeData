(define (modular-multiplicative-inverse a n)
    (if (< n 0)
        (setf n (abs n)))

    (if (< a 0)
        (setf a (- n (% (- 0 a) n))))

    (setf t 0)
    (setf nt 1)
    (setf r n)
    (setf nr (mod a n))

    (while (not (zero? nr))
        (setf q (int (div r nr)))
        (setf tmp nt)
        (setf nt (sub t (mul q nt)))
        (setf t tmp)
        (setf tmp nr)
        (setf nr (sub r (mul q nr)))
        (setf r tmp))

    (if (> r 1)
        (setf retvalue nil))

    (if (< t 0)
        (setf retvalue (add t n))
        (setf retvalue t))
    retvalue)

(println (modular-multiplicative-inverse 42 2017))
