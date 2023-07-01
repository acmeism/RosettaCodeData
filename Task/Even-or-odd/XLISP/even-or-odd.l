(defun my-evenp (x)
    (= (logand x 1) 0) )

(defun my-oddp (x)
    (/= (logand x 1) 0) )
