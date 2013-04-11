CL-USER> (defparameter *data* '(("a" "b" "c") ("" "q" "z") ("zap" "zip" "Zot")))
*DATA*

CL-USER> (sort-table *data*)
(("" "q" "z") ("a" "b" "c") ("zap" "zip" "Zot"))

CL-USER> (sort-table *data* :column 2)
(("zap" "zip" "Zot") ("a" "b" "c") ("" "q" "z"))

CL-USER> (sort-table *data* :column 1)
(("a" "b" "c") ("" "q" "z") ("zap" "zip" "Zot"))

CL-USER> (sort-table *data* :column 1 :reverse t)
(("zap" "zip" "Zot") ("" "q" "z") ("a" "b" "c"))

CL-USER> (sort-table *data* :ordering (lambda (a b) (> (length a) (length b))))
(("zap" "zip" "Zot") ("a" "b" "c") ("" "q" "z"))
