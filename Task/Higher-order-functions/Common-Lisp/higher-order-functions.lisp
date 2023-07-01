CL-USER> (defun add (a b) (+ a b))
ADD
CL-USER> (add 1 2)
3
CL-USER> (defun call-it (fn x y)
            (funcall fn x y))
CALL-IT
CL-USER> (call-it #'add 1 2)
3
