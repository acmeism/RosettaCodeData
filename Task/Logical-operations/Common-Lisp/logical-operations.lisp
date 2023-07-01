(defun demo-logic (a b)
  (mapcar (lambda (op)
                  (format t "~a ~a ~a is ~a~%" a op b (eval (list op a b))))
          '(and or)))

(loop for a in '(nil t) do
  (format t "NOT ~a is ~a~%" a (not a))
  (loop for b in '(nil t) do (demo-logic a b) (terpri)))
