$ clisp -q
[1]> (setf *print-circle* t)
T
[2]> (let ((a (cons 1 nil))) (setf (cdr a) a)) ;; create circular list
#1=(1 . #1#)
[3]> (read-from-string "#1=(1 . #1#)") ;; read it from a string
#1=(1 . #1#) ;; a similar circular list is returned
