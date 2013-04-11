(defun fact (n)
  "n is an integer, this function returns n!, that is n * (n - 1)
* (n - 2)....* 4 * 3 * 2 * 1"
  (cond
   ((= n 1) 1)
   (t (* n (fact (1- n))))))
