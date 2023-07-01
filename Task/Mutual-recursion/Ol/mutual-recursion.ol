(letrec ((F (lambda (n)
               (if (= n 0) 1
                  (- n (M (F (- n 1)))))))
         (M (lambda (n)
               (if (= n 0) 0
                  (- n (F (M (- n 1))))))))
   (print (F 19)))
; produces 12
