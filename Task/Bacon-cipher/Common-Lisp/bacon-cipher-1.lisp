;; 22.06.16

(defconstant +codes+
  '((#\a . (a a a a a)) (#\b . (a a a a b)) (#\c . (a a a b a))
    (#\d . (a a a b b)) (#\e . (a a b a a)) (#\f . (a a b a b))
    (#\g . (a a b b a)) (#\h . (a a b b b)) (#\i . (a b a a a))
    (#\j . (a b a a b)) (#\k . (a b a b a)) (#\l . (a b a b b))
    (#\m . (a b b a a)) (#\n . (a b b a b)) (#\o . (a b b b a))
    (#\p . (a b b b b)) (#\q . (b a a a a)) (#\r . (b a a a b))
    (#\s . (b a a b a)) (#\t . (b a a b b)) (#\u . (b a b a a))
    (#\v . (b a b a b)) (#\w . (b a b b a)) (#\x . (b a b b b))
    (#\y . (b b a a a)) (#\z . (b b a a b)) (#\space . (b b b a a))))

(defun encode (text message)
  (let (cipher key code)
    (loop for c across message do
      (setf code (cdr (assoc (char-downcase c) +codes+)))
      (setf key (append key code)))
    (loop for c across text always key do
      (when (alpha-char-p c)
        (if (eq (car key) 'B)
          (setf c (char-upcase c))
          (setf c (char-downcase c)))
        (setf key (cdr key)))
      (setf cipher (append cipher (list c))))
    (coerce cipher 'string)))

(defun decode (message)
  (let (key code letter)
    (loop for c across message when (alpha-char-p c) do
      (if (lower-case-p c)
        (setf code (append code '(A)))
        (setf code (append code '(B))))
      (when (= (length code) 5)
        (setf letter (car (rassoc code +codes+ :test #'equal)))
        (setf key (append key (list letter)))
        (setf code nil)))
      (coerce key 'string)))
