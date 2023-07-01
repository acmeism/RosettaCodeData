(let ((number (1+ (random 10))))
  (while (not (= (read-number "Guess the number ") number))
    (message "Wrong, try again."))
  (message "Well guessed! %d" number))
