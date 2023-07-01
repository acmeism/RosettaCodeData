(scl 4)
(load "@lib/misc.l")
(load "@lib/math.l")

(setq LOG10E 0.4343)

(de fibo (N)
   (let (A 0  B 1  C NIL)
      (make
         (link B)
         (do (dec N)
            (setq  C (+ A B)  A B  B C)
            (link B)))))

(setq Actual
   (let (
      Digits (sort (mapcar '((N) (format (car (chop N)))) (fibo 1000)))
      Count  0
   )
   (make
      (for (Ds Digits  Ds  (cdr Ds))
         (inc 'Count)
         (when (n== (car Ds) (cadr Ds))
            (link Count)
            (setq Count 0))))))

(setq Expected
   (mapcar
      '((D) (*/ (log (+ 1. (/ 1. D))) LOG10E 1.))
      (range 1 9)))

(prinl "Digit\tActual\tExpected")
(let (As Actual  Bs Expected)
   (for D 9
      (prinl D "\t" (format (pop 'As) 3) "\t" (round (pop 'Bs) 3))))

(bye)
