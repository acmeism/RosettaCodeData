(defconstant +a+ "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz")

(defun caesar (txt offset)
  (map 'string
    #'(lambda (c)
        (if (find c +a+)
          (char +a+ (mod (+ (position c +a+) (* 2 offset)) 52))
          c))
    txt))
