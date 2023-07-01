(defun doors (z &optional (w (make-list z)) (n 1))
  (if (> n z) w (doors z (toggle w n z) (1+ n))))

(defun toggle (w m z)
  (loop for a in w for n from 1 to z
        collect (if (zerop (mod n m)) (not a) a)))

> (doors 100)
(T NIL NIL T NIL NIL NIL NIL T NIL NIL NIL NIL NIL NIL T NIL NIL NIL NIL NIL
 NIL NIL NIL T NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL T NIL NIL NIL NIL NIL
 NIL NIL NIL NIL NIL NIL NIL T NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL
 NIL NIL T NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL T
 NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL T)
