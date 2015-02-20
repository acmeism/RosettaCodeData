(defun integer-to-list (n)
  (map 'list #'digit-char-p (prin1-to-string n)))

(defun narcissisticp (n)
  (let* ((lst (integer-to-list n))
         (e (length lst)))
        (= n
	   (reduce #'+ (mapcar (lambda (x) (expt x e)) lst)))))

(defun start ()
  (loop for c from 0
        while (< narcissistic 25)
        counting (narcissisticp c) into narcissistic
        do (if (narcissisticp c) (print c))))
