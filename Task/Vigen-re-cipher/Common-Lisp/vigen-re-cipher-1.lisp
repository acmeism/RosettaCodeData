(defun strip (s)
  (remove-if-not
    (lambda (c) (char<= #\A c #\Z))
    (string-upcase s)))

(defun vigenère (s key &key decipher
			&aux (A (char-code #\A))
			     (op (if decipher #'- #'+)))
  (labels
    ((to-char (c) (code-char (+ c A)))
     (to-code (c) (- (char-code c) A)))
    (let ((k (map 'list #'to-code (strip key))))
      (setf (cdr (last k)) k)
      (map 'string
	   (lambda (c)
	     (prog1
	       (to-char
		 (mod (funcall op (to-code c) (car k)) 26))
	       (setf k (cdr k))))
	   (strip s)))))

(let* ((msg "Beware the Jabberwock... The jaws that... the claws that catch!")
       (key "vigenere cipher")
       (enc (vigenère msg key))
       (dec (vigenère enc key :decipher t)))
  (format t "msg: ~a~%enc: ~a~%dec: ~a~%" msg enc dec))
