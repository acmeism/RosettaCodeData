(format t "~{~:[~&~;~:*~:(~a~)~]~}"
  (loop as n from 1 to 100
        as f = (zerop (mod n 3))
        as b = (zerop (mod n 5))
        collect nil
        if f collect 'fizz
        if b collect 'buzz
        if (not (or f b)) collect n))
