(defun my-recurse (n)
  (my-recurse (1+ n)))
(my-recurse 1)
=>
enters debugger at (my-recurse 595),
per the default max-lisp-eval-depth 600 in Emacs 24.1
