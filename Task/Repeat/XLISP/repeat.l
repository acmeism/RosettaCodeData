(defun repeat (f n)
    (f)
    (if (> n 1)
        (repeat f (- n 1)) ) )

;; an example to test it:
(repeat (lambda () (print '(hello rosetta code))) 5)
