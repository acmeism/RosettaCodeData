(defun count-equal-chars (string1 string2)
  (loop for c1 across string1 and c2 across string2
        count (char= c1 c2)))

(defun shuffle (string)
  (let ((length (length string))
        (result (copy-seq string)))
    (dotimes (i length result)
      (dotimes (j length)
        (when (and (/= i j)
                   (char/= (aref string i) (aref result j))
                   (char/= (aref string j) (aref result i)))
          (rotatef (aref result i) (aref result j)))))))

(defun best-shuffle (list)
  (dolist (string list)
    (let ((shuffled (shuffle string)))
      (format t "~%~a ~a (~a)"
              string
              shuffled
              (count-equal-chars string shuffled)))))

(best-shuffle '("abracadabra" "seesaw" "elk" "grrrrrr" "up" "a"))
