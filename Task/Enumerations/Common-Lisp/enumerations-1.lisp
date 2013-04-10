;; symbol to number
(defconstant +apple+ 0)
(defconstant +banana+ 1)
(defconstant +cherry+ 2)

;; number to symbol
(defun index-fruit (i)
  (aref #(+apple+ +banana+ +cherry+) i))
