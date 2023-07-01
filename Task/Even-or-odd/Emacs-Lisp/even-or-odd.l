(require 'cl-lib)

(defun even-or-odd-p (n)
  (if (cl-evenp n) 'even 'odd))

(defun even-or-odd-p (n)
 (if (zerop (% n 2)) 'even 'odd))

(message "%d is %s" 3 (even-or-oddp 3))
(message "%d is %s" 2 (even-or-oddp 2))
