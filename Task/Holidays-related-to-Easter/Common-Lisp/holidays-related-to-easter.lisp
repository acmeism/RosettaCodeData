; Easter sunday. Result is a list '(month day)
;
; See:
; Jean Meeus, "Astronomical Formulae for Calculators",
; 4th edition, Willmann-Bell, 1988, p.31

(defun easter (year)
  (let (a b c d e f g h i k l m n p)
    (setq a (rem year 19))
    (multiple-value-setq (b c) (floor year 100))
    (multiple-value-setq (d e) (floor b 4))
    (setq f (floor (+ b 8) 25))
    (setq g (floor (- b f -1) 3))
    (setq h (rem (+ (* 19 a) (- b d g) 15) 30))
    (multiple-value-setq (i k) (floor c 4))
    (setq l (rem (+ 32 e e i (- i h k)) 7))
    (setq m (floor (+ a (* 11 h) (* 22 l)) 451))
    (multiple-value-setq (n p) (floor (+ h l (- 114 (* 7 m))) 31))
    (list n (1+ p))))
