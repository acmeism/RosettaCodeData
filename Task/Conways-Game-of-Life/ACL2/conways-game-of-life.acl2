(defun print-row (row)
   (if (endp row)
       nil
       (prog2$ (if (first row)
                   (cw "[]")
                   (cw "  "))
               (print-row (rest row)))))

(defun print-grid-r (grid)
   (if (endp grid)
       nil
       (progn$ (cw "|")
               (print-row (first grid))
               (cw "|~%")
               (print-grid-r (rest grid)))))

(defun print-line (l)
   (if (zp l)
       nil
       (prog2$ (cw "-")
               (print-line (1- l)))))

(defun print-grid (grid)
   (progn$ (cw "+")
           (print-line (* 2 (len (first grid))))
           (cw "+~%")
           (print-grid-r grid)
           (cw "+")
           (print-line (* 2 (len (first grid))))
           (cw "+~%")))

(defun neighbors-row-r (row)
   (if (endp (rest (rest row)))
       (list (if (first row) 1 0))
       (cons (+ (if (first row) 1 0)
                (if (third row) 1 0))
             (neighbors-row-r (rest row)))))

(defun neighbors-row (row)
   (cons (if (second row) 1 0)
         (neighbors-row-r row)))

(defun zip+ (xs ys)
   (if (or (endp xs) (endp ys))
       (append xs ys)
       (cons (+ (first xs) (first ys))
             (zip+ (rest xs) (rest ys)))))

(defun counts-row (row)
   (if (endp row)
       nil
       (cons (if (first row) 1 0)
             (counts-row (rest row)))))

(defun neighbors-r (grid prev-counts curr-counts next-counts
                         prev-neighbors curr-neighbors
                         next-neighbors)
   (if (endp (rest grid))
       (list (zip+ (zip+ prev-counts
                         prev-neighbors)
                   (neighbors-row (first grid))))
       (cons (zip+ (zip+ (zip+ prev-counts next-counts)
                         (zip+ prev-neighbors next-neighbors))
                   curr-neighbors)
             (neighbors-r (rest grid)
                          curr-counts
                          next-counts
                          (counts-row (third grid))
                          curr-neighbors
                          next-neighbors
                          (neighbors-row (third grid))))))

(defun neighbors (grid)
   (neighbors-r grid
                nil
                (counts-row (first grid))
                (counts-row (second grid))
                nil
                (neighbors-row (first grid))
                (neighbors-row (second grid))))

(defun life-rules-row (life neighbors)
   (if (or (endp life) (endp neighbors))
       nil
       (cons (or (and (first life)
                      (or (= (first neighbors) 2)
                          (= (first neighbors) 3)))
                 (and (not (first life))
                      (= (first neighbors) 3)))
             (life-rules-row (rest life) (rest neighbors)))))

(defun life-rules-r (grid neighbors)
   (if (or (endp grid) (endp neighbors))
       nil
       (cons (life-rules-row (first grid) (first neighbors))
             (life-rules-r (rest grid) (rest neighbors)))))

(defun conway-step (grid)
   (life-rules-r grid (neighbors grid)))

(defun conway (grid steps)
   (if (zp steps)
       nil
       (progn$ (print-grid grid)
               (conway (conway-step grid) (1- steps)))))
