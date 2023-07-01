(dolist (r '("MCMXC" "MDCLXVI" "MMVIII"))
  (format t "~a:~10t~d~%" r (parse-roman r)))
