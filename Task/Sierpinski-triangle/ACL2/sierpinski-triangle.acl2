(defun pascal-row (prev)
   (if (endp (rest prev))
       (list 1)
       (cons (+ (first prev) (second prev))
             (pascal-row (rest prev)))))

(defun pascal-triangle-r (rows prev)
   (if (zp rows)
       nil
       (let ((curr (cons 1 (pascal-row prev))))
          (cons curr (pascal-triangle-r (1- rows) curr)))))

(defun pascal-triangle (rows)
   (cons (list 1)
         (pascal-triangle-r rows (list 1))))

(defun print-odds-row (row)
   (if (endp row)
       (cw "~%")
       (prog2$ (cw (if (oddp (first row)) "[]" "  "))
               (print-odds-row (rest row)))))

(defun print-spaces (n)
   (if (zp n)
       nil
       (prog2$ (cw " ")
               (print-spaces (1- n)))))

(defun print-odds (triangle height)
   (if (endp triangle)
       nil
       (progn$ (print-spaces height)
               (print-odds-row (first triangle))
               (print-odds (rest triangle) (1- height)))))

(defun print-sierpenski (levels)
   (let ((height (1- (expt 2 levels))))
      (print-odds (pascal-triangle height)
                  height)))
