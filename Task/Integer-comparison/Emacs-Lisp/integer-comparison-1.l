(progn
  (if (< 1 2) (insert "True\n") (insert "False\n") )
  (if (= 1 2) (insert "True\n") (insert "False\n") )
  (if (= 1 1) (insert "True\n") (insert "False\n") )
  (if (> 1 2) (insert "True\n") (insert "False\n") )
  (if (<= 1 2) (insert "True\n") (insert "False\n") )
  (if (>= 1 2) (insert "True\n") (insert "False\n") ))
