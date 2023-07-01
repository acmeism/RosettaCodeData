(defun roots-of-unity (n)
 (loop for i below n
       collect (cis (* pi (/ (* 2 i) n)))))
