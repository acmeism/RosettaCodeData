(defun my-nvreverse (list)
  (loop with prev = nil
        until (null list)
        do (rotatef (cdr list) prev list)
        finally (return prev)))
