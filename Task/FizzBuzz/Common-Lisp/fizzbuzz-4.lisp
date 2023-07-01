(loop as n from 1 to 100
      as fizz = (zerop (mod n 3))
      as buzz = (zerop (mod n 5))
      as numb = (not (or fizz buzz))
      do
  (format t
   "~&~:[~;Fizz~]~:[~;Buzz~]~:[~;~D~]~%"
   fizz buzz numb n))
