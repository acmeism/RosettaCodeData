(defconstant +alphabet+
'(#\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M #\N #\O #\P
  #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z))

(defun rot13 (s)
  (map 'string
    (lambda (c &aux (n (position (char-upcase c) +alphabet+)))
      (if n
        (funcall
          (if (lower-case-p c) #'char-downcase #'identity)
          (nth (mod (+ 13 n) 26) +alphabet+))
        c))
    s))
