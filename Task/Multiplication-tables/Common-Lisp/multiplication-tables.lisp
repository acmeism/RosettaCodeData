(do ((m 0 (if (= 12 m) 0 (1+ m)))
     (n 0 (if (= 12 m) (1+ n) n)))
    ((= n 13))
  (if (zerop n)
      (case m
        (0 (format t "  *|"))
        (12 (format t "  12~&---+------------------------------------------------~&"))
        (otherwise
         (format t "~4,D" m)))
      (case m
        (0 (format t "~3,D|" n))
        (12 (format t "~4,D~&" (* n m)))
        (otherwise
         (if (>= m n)
             (format t "~4,D" (* m n))
             (format t "    "))))))
