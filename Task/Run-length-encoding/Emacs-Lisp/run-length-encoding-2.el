(require 'seq)

(defun run-length-encode (str)
  (let ((grouped (mapcar #'cdr (seq-group-by #'identity (string-to-list str)))))
    (apply #'concat (mapcar (lambda (items)
                              (format "%d%c" (length items) (car items)))
                            grouped))))
