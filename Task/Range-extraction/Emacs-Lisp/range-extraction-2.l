(setq max-lisp-eval-depth 10000)

(defun ab (a ls)
  (if ls (if (= (+ a 1) (car ls) )
	     (abc a (car ls) (cdr ls) )
	   (format "%d,%s" a (ab (car ls) (cdr ls) )))
    (format "%d" a) ))

(defun abc (a b ls)
  (if ls (if (= (+ b 1) (car ls) )
	     (abcd a (car ls) (cdr ls) )
	   (format "%d,%d,%s" a b (ab (car ls) (cdr ls) )))
    (format "%d,%d" a b) ))

(defun abcd (a c ls)
  (if ls (if (= (+ c 1) (car ls) )
	     (abcd a (car ls) (cdr ls) )
	   (format "%d-%d,%s" a c (ab (car ls) (cdr ls) )))
    (format "%d-%d" a c) ))

(defun rangext (ls)
  (if ls (ab (car ls) (cdr ls) ) ""))

(insert (rangext '(0  1  2  4  6  7  8 11 12 14
           15 16 17 18 19 20 21 22 23 24
           25 27 28 29 30 31 32 33 35 36
           37 38 39) ))
