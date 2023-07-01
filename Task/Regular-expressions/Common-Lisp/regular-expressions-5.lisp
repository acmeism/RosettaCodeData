[2]> (defun regexp-replace (pat repl string)
  (reduce #'(lambda (x y) (string-concat x repl y))
          (regexp:regexp-split pat string)))
REGEXP-REPLACE
[3]> (regexp-replace "x\\b" "-X-" "quick foxx jumps")
"quick fox-X- jumps"
