(defun shuffle (list)                        ;; Z not uniform
  (sort list '> :key (lambda(x) (random 1.0))))

(defun neighbors (x y maze)
  (remove-if-not
   (lambda (x-y) (and (< -1 (first x-y) (array-dimension maze 0))
                 (< -1 (second x-y) (array-dimension maze 1))))
   `((,x ,(+ y 2)) (,(- x 2) ,y) (,x ,(- y 2)) (,(+ x 2) ,y))))

(defun remove-wall (maze x y &optional visited)
  (labels ((walk (maze x y)
             (push (list x y) visited)
             (loop for (u v) in (shuffle (neighbors x y maze))
                unless (member (list u v) visited :test 'equal)
                do (setf (aref maze u v) #\space
                         (aref maze (/ (+ x u) 2) (/ (+ y v) 2)) #\space)
                   (walk maze u v))))
    (setf (aref maze x y) #\space)
    (walk maze x y)))

(defun draw-maze (width height &key (block #\BOX_DRAWINGS_LIGHT_DIAGONAL_CROSS))
  (let ((maze (make-array (list (1+ (* 2 height)) (1+ (* 2 width)))
                          :element-type 'character :initial-element block)))
    (remove-wall maze (1+ (* 2 (random height))) (1+ (* 2 (random width))))
    (loop for i below (array-dimension maze 0)
          do (fresh-line)
             (loop for j below (array-dimension maze 1)
                   do (princ (aref maze i j))))))

(draw-maze 20 6)
