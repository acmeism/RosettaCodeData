;; returns a list of bits: '(sum carry)
(defun half-adder (a b)
  (list (logxor a b) (logand a b)))

;; returns a list of bits: '(sum, carry)
(defun full-adder (a b c-in)
  (let*
    ((h1 (half-adder c-in a))
    (h2 (half-adder (first h1) b)))
    (list (first h2) (logior (second h1) (second h2)))))

;; a and b are lists of 4 bits each
(defun 4-bit-adder (a b)
  (let*
    ((add-1 (full-adder (fourth a) (fourth b) 0))
      (add-2 (full-adder (third a) (third b) (second add-1)))
      (add-3 (full-adder (second a) (second b) (second add-2)))
      (add-4 (full-adder (first a) (first b) (second add-3))))
    (list
      (list (first add-4) (first add-3) (first add-2) (first add-1))
      (second add-4))))

(defun main ()
  (print (4-bit-adder (list 0 0 0 0) (list 0 0 0 0)))   ;; '(0 0 0 0) and 0
  (print (4-bit-adder (list 0 0 0 0) (list 1 1 1 1)))   ;; '(1 1 1 1) and 0
  (print (4-bit-adder (list 1 1 1 1) (list 0 0 0 0)))   ;; '(1 1 1 1) and 0
  (print (4-bit-adder (list 0 1 0 1) (list 1 1 0 0)))   ;; '(0 0 0 1) and 1
  (print (4-bit-adder (list 1 1 1 1) (list 1 1 1 1)))   ;; '(1 1 1 0) and 1
  (print (4-bit-adder (list 1 0 1 0) (list 0 1 0 1)))   ;; '(1 1 1 1) and 0
 )

(main)
