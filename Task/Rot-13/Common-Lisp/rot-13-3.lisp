(defconstant +a+ "AaBbCcDdEeFfGgHhIiJjKkLlMmzZyYxXwWvVuUtTsSrRqQpPoOnN")

(defun rot (txt)
  (map 'string
    #'(lambda (x)
        (if (find x +a+)
          (char +a+ (- 51 (position x +a+)))
          x))
    txt))
