(defun swap (a-sym b-sym)
  "Swap values of the variables given by A-SYM and B-SYM."
  (let ((a-val (symbol-value a-sym)))
    (set a-sym (symbol-value b-sym))
    (set b-sym a-val)))
(swap 'a 'b)
