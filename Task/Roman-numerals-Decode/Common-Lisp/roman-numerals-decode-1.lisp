(defun mapcn (chars nums string)
  (loop as char across string as i = (position char chars) collect (and i (nth i nums))))

(defun parse-roman (R)
  (loop with nums = (mapcn "IVXLCDM" '(1 5 10 50 100 500 1000) R)
        as (A B) on nums if A sum (if (and B (< A B)) (- A) A)))
