(defun my-print-args (&rest arg-list)
  (message "there are %d argument(s)" (length arg-list))
  (dolist (arg arg-list)
    (message "arg is %S" arg)))

(my-print-args 1 2 3)
