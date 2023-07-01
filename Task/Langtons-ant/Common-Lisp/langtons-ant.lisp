(defmacro toggle (gv) `(setf  ,gv (not ,gv)))

(defun langtons-ant (width height start-x start-y start-dir)
  (let ( (grid (make-array (list width height)))
         (x start-x)
         (y start-y)
         (dir start-dir) )
    (loop while (and (< -1 x width) (< -1 y height)) do
      (if (toggle (aref grid x y))
        (setq dir (mod (1+ dir) 4))
        (setq dir (mod (1- dir) 4)))
      (case dir
        (0 (decf y))
        (1 (incf x))
        (2 (incf y))
        (3 (decf x)))
    )
    grid
  )
)

(defun show-grid (grid)
  (destructuring-bind (width height) (array-dimensions grid)
    (dotimes (y height)
      (dotimes (x width)
        (princ (if (aref grid x y) "#" ".")))
      (princ #\Newline))
  )
)

(setf *random-state* (make-random-state t))
(show-grid (langtons-ant 100 100 (+ 45 (random 10)) (+ 45 (random 10)) (random 4)))
