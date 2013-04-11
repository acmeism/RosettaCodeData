(require :curly)
(use-package :curly)
(enable-curly-syntax)

(defun luhn (seq)
  (labels ((sum-digits (n) (if (> n 9) (- n 9) n)))
    (funcall {zerop (mod * 10) (apply #'+) (mapcar #'sum-digits)
	     (mapcar #'* '#1=(1 2 . #1#)) (map 'list #'digit-char-p) reverse} seq)))
