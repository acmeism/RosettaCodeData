(defun string-valid-number-p (str)
  "Test if STR is a numeric string.
Eliminate strings with commas in them because ELisp numbers do
not contain commas. Then check if remaining strings would be
valid ELisp numbers if the quotation marks were removed."
  (and
   ;; no comma in string, because ELisp numbers do not have commas
   ;; we need to eliminate any string with a comma, because the
   ;; numberp function below will not weed out commas
   (not (string-match-p "," str))
   ;; no errors from numberp function testing if a number
   (ignore-errors (numberp (read str)))))
