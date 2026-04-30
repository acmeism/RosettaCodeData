(defun store-keypress ()
  "If a key has been pressed, store it as a variable.
Note that the variable created is a variable inside the scope of let and
will not be available as a variable outside the scope of let. However,
the function also returns the value of the variable, which can be used
outside the scope of let."
  (let ((keypress))
    (if (input-pending-p)
        (setq keypress (char-to-string (read-key))))))


(defun store-keypress-multiple ()
  "If one or more keys have been pressed, store it/them as a variable.
Note that the variable created is a variable inside the scope of let and
will not be available as a variable outside the scope of let. However,
the function also returns the value of the variable, which can be used
outside the scope of let."
  (let ((keypress))
    (while (input-pending-p)
      (push (read-key)  keypress))
    (setq keypress (concat (nreverse keypress)))))
