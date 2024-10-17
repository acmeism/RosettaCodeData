(defun chr->num (chr)
  (nth (position chr "IVXLCDM") '(1 5 10 50 100 500 1000)))

(defun parse-rmn (str)
  (let ((lst (map 'list #'chr->num str)))
    (apply '+
      (mapcar
        (lambda (a b) (if (< a b) (- a) a))
        (cons 0 lst)
        (append lst '(0))))))
