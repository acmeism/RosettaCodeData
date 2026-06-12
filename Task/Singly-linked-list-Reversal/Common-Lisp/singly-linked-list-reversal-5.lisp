(defun my-nreverse (list)
  (loop for next = (cdr list) then (cdr next)
        and cur = list then next
        and prev = nil then cur
        until (endp cur)
        do (setf (cdr cur) prev)
        finally (return prev)))
