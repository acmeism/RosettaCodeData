(defparameter *n* 9516311845790656153499716760847001433441357)
(defparameter *e* 65537)
(defparameter *d* 5617843187844953170308463622230283376298685)

;; magic
(defun encode-string (message)
  (parse-integer (reduce #'(lambda (x y) (concatenate 'string x y))
     (loop for c across message collect (format nil "~2,'0d" (- (char-code c) 32))))))

;; sorcery
(defun decode-string (message) (coerce (loop for (a b) on
  (loop for char across (write-to-string message) collect char)
    by #'cddr collect (code-char (+ (parse-integer (coerce (list a b) 'string)) 32))) 'string))

;; ACTUAL RSA ALGORITHM STARTS HERE ;;

;; fast modular exponentiation: runs in O(log exponent)
;; acc is initially 1 and contains the result by the end
(defun mod-exp (base exponent modulus acc)
  (if (= exponent 0) acc
    (mod-exp (mod (* base base) modulus) (ash exponent -1) modulus
	     (if (= (mod exponent 2) 1) (mod (* acc base) modulus) acc))))

;; to encode a message, we first convert it to its integer form.
;; then, we raise it to the *e* power, modulo *n*
(defun encode-rsa (message)
  (mod-exp (encode-string message) *e* *n* 1))

;; to decode a message, we raise it to *d* power, modulo *n*
;; and then convert it back into a string
(defun decode-rsa (message)
  (decode-string (mod-exp message *d* *n* 1)))
