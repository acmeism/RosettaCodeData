(dolist (i '(3 1 4 1 5 92 65 3 5 89 79 3))
  (run-with-timer (* i 0.001) nil 'message "%d" i))
