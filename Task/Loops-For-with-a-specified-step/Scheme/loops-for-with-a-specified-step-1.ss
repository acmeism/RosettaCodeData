(do ((i 2 (+ i 2)))  ; list of variables, initials and steps -- you can iterate over several at once
  ((>= i 9))         ; exit condition
  (display i)        ; body
  (newline))
