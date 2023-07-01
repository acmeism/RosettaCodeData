(defun a (F)
     (print 'a)
     F )

(defun b (F)
     (print 'b)
     F )

(dolist (x '((nil nil) (nil T) (T T) (T nil)))
        (format t "~%(and ~S)" x)
        (and (a (car x)) (b (car(cdr x))))
        (format t "~%(or ~S)" x)
        (or (a (car x)) (b (car(cdr x)))))
