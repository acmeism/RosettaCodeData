(defconstant +max-score+ 100)
(defconstant +n-of-players+ 2)

(let ((scores (make-list +n-of-players+ :initial-element 0))
      (current-player 0)
      (round-score 0))
  (loop
     (format t "Player ~d: (~d, ~d). Rolling? (Y)"
             current-player
             (nth current-player scores)
             round-score)
     (if (member (read-line) '("y" "yes" "") :test #'string=)
         (let ((roll (1+ (random 6))))
           (format t "~tRolled ~d~%" roll)
           (if (= roll 1)
               (progn
                 (format t
                         "~tBust! you lose ~d but still keep your previous ~d~%"
                         round-score (nth current-player scores))
                 (setf round-score 0)
                 (setf current-player
                       (mod (1+ current-player) +n-of-players+)))
               (incf round-score roll)))
         (progn
           (incf (nth current-player scores) round-score)
           (setf round-score 0)
           (when (>= (apply #'max scores) 100)
             (return))
           (format t "~tSticking with ~d~%" (nth current-player scores))
           (setf current-player (mod (1+ current-player) +n-of-players+)))))
  (format t "~%Player ~d wins with a score of ~d~%" current-player
          (nth current-player scores)))
