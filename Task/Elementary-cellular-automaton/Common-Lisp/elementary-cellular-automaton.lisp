(defun automaton (init rule &optional (stop 10))
  (labels ((next-gen (cells)
             (mapcar #'new-cell
                     (cons (car (last cells)) cells)
                     cells
                     (append (cdr cells) (list (car cells)))))

           (new-cell (left current right)
             (let ((shift (+ (* left 4) (* current 2) right)))
               (if (logtest rule (ash 1 shift)) 1 0)))

           (pretty-print (cells)
             (format T "~{~a~}~%"
                     (mapcar (lambda (x) (if (zerop x) #\. #\#))
                             cells))))

    (loop for cells = init then (next-gen cells)
          for i below stop
          do (pretty-print cells))))

(automaton '(0 0 0 0 0 0 1 0 0 0 0 0 0) 90)
