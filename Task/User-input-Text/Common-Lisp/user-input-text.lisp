(format t "Enter some text: ")
(let ((s (read-line)))
    (format t "You entered ~s~%" s))

(format t "Enter a number: ")
(let ((n (read)))
    (if (numberp n)
        (format t "You entered ~d.~%" n)
      (format t "That was not a number.")))
