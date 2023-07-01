(defun proper-divisors-recursive (product &optional (results '(1)))
   "(int,list)->list::Function to find all proper divisors of a +ve integer."

   (defun smallest-divisor (x)
      "int->int::Find the smallest divisor of an integer > 1."
      (if (evenp x) 2
          (do ((lim (truncate (sqrt x)))
               (sd 3 (+ sd 2)))
              ((or (integerp (/ x sd)) (> sd lim)) (if (> sd lim) x sd)))))

   (defun pd-rec (fac)
      "(int,int)->nil::Recursive function to find proper divisors of a +ve integer"
      (when (not (member fac results))
         (push fac results)
         (let ((hifac (/ fac (smallest-divisor fac))))
            (pd-rec hifac)
            (pd-rec (/ product hifac)))))

   (pd-rec product)
   (butlast (sort (copy-list results) #'<)))

(defun task (method &optional (n 1) (most-pds '(0)))
   (dotimes (i 19999)
      (let ((npds (length (funcall method (incf n))))
            (hiest (car most-pds)))
         (when (>= npds hiest)
            (if (> npds hiest)
                (setf most-pds (list npds (list n)))
                (setf most-pds (list npds (cons n (second most-pds))))))))
   most-pds)

(defun main ()
   (format t "Task 1:Proper Divisors of [1,10]:~%")
   (dotimes (i 10) (format t "~A:~A~%" (1+ i) (proper-divisors-recursive (1+ i))))
   (format t "Task 2:Count & list of numbers <=20,000 with the most Proper Divisors:~%~A~%"
           (task #'proper-divisors-recursive)))
