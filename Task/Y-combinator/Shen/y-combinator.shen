(define y
  F -> ((/. X (X X))
        (/. X (F (/. Z ((X X) Z))))))

(let Fac (y (/. F N (if (= 0 N)
                      1
                      (* N (F (- N 1))))))
  (output "~A~%~A~%~A~%"
    (Fac 0)
    (Fac 5)
    (Fac 10)))
