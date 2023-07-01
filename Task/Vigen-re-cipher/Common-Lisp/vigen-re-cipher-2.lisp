(defconstant +a+ "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

(defun strip (s)
  (string-upcase (remove-if-not 'alpha-char-p s)))

(defun vigenere (txt key &key plain &aux (p (if plain -1 1)))
  (let ((txt (strip txt)) (key (strip key)) (i -1))
    (map 'string
      (lambda (c)
        (setf i (mod (1+ i) (length key)))
        (char +a+ (mod (+ (position c +a+) (* p (position (elt key i) +a+))) 26)))
      txt)))
