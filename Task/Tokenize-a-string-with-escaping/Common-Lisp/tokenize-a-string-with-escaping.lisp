(defun split (input separator escape)
  (flet ((make-string-buffer ()
           (make-array 0 :element-type 'character :adjustable t :fill-pointer t)))
    (loop with token = (make-string-buffer)
          with result = nil
          with to-be-escaped = nil
          for ch across input
          do (cond (to-be-escaped
                    (vector-push-extend ch token)
                    (setf to-be-escaped nil))
                   ((char= ch escape)
                    (setf to-be-escaped t))
                   ((char= ch separator)
                    (push token result)
                    (setf token (make-string-buffer)))
                   (t
                    (vector-push-extend ch token)))
          finally (push token result)
                  (return (nreverse result)))))

(defun main ()
  (dolist (token (split "one^|uno||three^^^^|four^^^|^cuatro|" #\| #\^))
    (format t "'~A'~%" token)))
