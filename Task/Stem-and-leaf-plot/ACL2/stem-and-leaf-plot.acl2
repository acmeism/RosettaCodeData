(defun insert (x xs)
   (cond ((endp xs) (list x))
         ((> x (first xs))
          (cons (first xs) (insert x (rest xs))))
         (t (cons x xs))))

(defun isort (xs)
   (if (endp xs)
       nil
       (insert (first xs) (isort (rest xs)))))

(defun stem-and-leaf-bins (xs bin curr)
   (cond ((endp xs) (list curr))
         ((= (floor (first xs) 10) bin)
          (stem-and-leaf-bins (rest xs)
                              bin
                              (cons (first xs) curr)))
         (t (cons curr
                  (stem-and-leaf-bins (rest xs)
                                      (floor (first xs) 10)
                                      (list (first xs)))))))

(defun print-bin (bin)
   (if (endp bin)
       nil
       (progn$ (cw " ~x0" (mod (first bin) 10))
               (print-bin (rest bin)))))

(defun stem-and-leaf-plot-r (bins)
   (if (or (endp bins) (endp (first bins)))
       nil
       (progn$ (cw "~x0 |" (floor (first (first bins)) 10))
               (print-bin (first bins))
               (cw "~%")
               (stem-and-leaf-plot-r (rest bins)))))

(defun stem-and-leaf-plot (xs)
   (stem-and-leaf-plot-r
    (reverse (stem-and-leaf-bins (reverse (isort xs))
                                 0
                                 nil))))
