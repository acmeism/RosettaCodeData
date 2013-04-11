(defun mod-expt (a n m)
   (loop with c = 1 while (plusp n) do
      (if (oddp n) (setf c (mod (* a c) m)))
      (setf n (ash n -1))
      (setf a (mod (* a a) m))
      finally (return c)))
