(defun beer-verse (count)
  "Recurses the verses"
  (format t "~A bottle~A of beer on the wall~%"
    count
    (if (/= count 1) "s" ""))
  (format t "~A bottle~A of beer~%"
    count
    (if (/= count 1) "s" ""))
  (format t "Take one down, pass it round~%")
  (format t "~A bottle~A of beer on the wall~%~%"
    (if (= count 1)
      "No"
      (- count 1))
    (if (/= count 2)
      "s"
      ""))
  (if (> count 1)
    (beer-verse (- count 1))))
(beer-verse 99)
