(defun point-in-polygon (point polygon)
  (do ((in-p nil)) ((endp polygon) in-p)
    (when (ray-intersects-segment point (pop polygon))
      (setf in-p (not in-p)))))

(defun ray-intersects-segment (point segment &optional (epsilon .001))
  (destructuring-bind (px . py) point
    (destructuring-bind ((ax . ay) . (bx . by)) segment
      (when (< ay by)
        (rotatef ay by)
        (rotatef ax bx))
      (when (or (= py ay) (= py by))
        (incf py epsilon))
      (cond
       ;; point is above, below, or to the right of the rectangle
       ;; determined by segment; ray does not intesect the segment.
       ((or (> px (max ax bx)) (> py (max ay by)) (< py (min ay by)))
        nil)
       ;; point is to left of the rectangle; ray intersects segment
       ((< px (min ax bx))
        t)
       ;; point is within the rectangle...
       (t (let ((m-red (if (= ax bx) nil
                         (/ (- by ay) (- bx ax))))
                (m-blue (if (= px ax) nil
                          (/ (- py ay) (- px ax)))))
            (cond
             ((null m-blue) t)
             ((null m-red) nil)
             (t (>= m-blue m-red)))))))))
