(setf (symbol-function '^) #'expt)  ; Make ^ an alias for EXPT

(defun print-stack (token stack)
    (format T "~a: ~{~a ~}~%" token (reverse stack)))

(defun rpn (tokens &key stack verbose )
  (cond
    ((and (not tokens) (not stack)) 0)
    ((not tokens) (car stack))
    (T
      (let* ((current (car tokens))
             (next-stack (if (numberp current)
                           (cons current stack)
                           (let* ((arg2 (car stack))
                                  (arg1 (cadr stack))
                                  (fun (car tokens)))
                             (cons (funcall fun arg1 arg2) (cddr stack))))))
        (when verbose
          (print-stack current next-stack))
        (rpn (cdr tokens) :stack next-stack :verbose verbose)))))
