(defun quibble (&rest args)
  (format t "{~{~a~#[~; and ~:;, ~]~}}" args))

(quibble)
(quibble "ABC")
(quibble "ABC" "DEF")
(quibble "ABC" "DEF" "G" "H")
