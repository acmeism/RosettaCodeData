(defun encipher-char (ch key)
  (let*
    ((c  (char-code  ch))
     (la (char-code #\a)) (lz (char-code #\z))
     (ua (char-code #\A)) (uz (char-code #\Z))
     (base (cond
            ((and (>= c la) (<= c lz)) la)
            ((and (>= c ua) (<= c uz)) ua)
            (t nil))))
     (if base (code-char (+ (mod (+ (- c base) key) 26) base)) ch)))

(defun caesar-cipher (str key)
  (map 'string #'(lambda (c) (encipher-char c key)) str))

(defun caesar-decipher (str key) (caesar-cipher str (- key)))

(let* ((original-text "The five boxing wizards jump quickly")
       (key 3)
       (cipher-text (caesar-cipher original-text key))
       (recovered-text (caesar-decipher cipher-text key)))
  (format t " Original: ~a ~%" original-text)
  (format t "Encrypted: ~a ~%" cipher-text)
  (format t "Decrypted: ~a ~%" recovered-text))
