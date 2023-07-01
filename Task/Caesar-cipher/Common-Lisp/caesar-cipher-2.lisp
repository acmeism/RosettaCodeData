(defun caesar-encipher (s k)
  (map 'string #'(lambda (c) (z c k)) s))

(defun caesar-decipher (s k) (caesar-encipher s (- k)))

(defun z (h k &aux (c (char-code  h))
                   (b (or (when (<= 97 c 122) 97)
                          (when (<= 65 c 90) 65))))
  (if b (code-char (+ (mod (+ (- c b) k) 26) b)) h))
