(defun dutch-flag-order (color)
  (case color (:red 1) (:white 2) (:blue 3)))

(defun sort-in-dutch-flag-order (balls)
  (sort (copy-list balls) #'< :key #'dutch-flag-order))

(defun make-random-balls (count)
  (loop :repeat count
        :collect (nth (random 3) '(:red :white :blue))))

(defun make-balls (count)
  (loop :for balls = (make-random-balls count)
        :while (equal balls (sort-in-dutch-flag-order balls))
        :finally (return balls)))

;; Alternative version showcasing iterate's finding clause
(defun make-balls2 (count)
  (iter (for balls = (make-random-balls count))
    (finding balls such-that (not (equal balls (sort-in-dutch-flag-order balls))))))
