(format t "~{~{~:[~;Fizz~]~:[~;Buzz~]~:[~*~;~d~]~}~%~}"
  (loop as n from 1 to 100
        as f = (zerop (mod n 3))
        as b = (zerop (mod n 5))
        collect (list f b (not (or f b)) n)))
