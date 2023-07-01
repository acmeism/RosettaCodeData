(defmodule deceptives
   (export (prime? 1) (deceptives 1)))

(defun prime? (n)
   (if (< n 2)
      'false
      (prime? n 2 0 #B(1 2 2 4 2 4 2 4 6 2 6))))

(defun prime? (n d j wheel)
   (cond
      ((=:= j (byte_size wheel))
         (prime? n d 3 wheel))
      ((> (* d d) n)
         'true)
      ((=:= 0 (rem n d))
         'false)
      (else
         (prime? n (+ d (binary:at wheel j)) (+ j 1) wheel))))

(defun deceptives (n)
   (deceptives 2 1 n '()))

(defun deceptives
   ((_ _ 0 l)
      (lists:reverse l))
   ((k r n l)
      (if (andalso (not (prime? k)) (=:= 0 (rem r k)))
         (deceptives (+ k 1) (+ (* r 10) 1) (- n 1) (cons k l))
         (deceptives (+ k 1) (+ (* r 10) 1) n l))))
