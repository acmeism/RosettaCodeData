(use srfi-42)     ;; for Gauche or Chicken
  or
(require srfi/42) ;; for Racket

(list-ec (: x 1 21)
         (: y x 21)
         (: z y 21)
         (if (= (* z z) (+ (* x x) (* y y))))
         (list x y z))
