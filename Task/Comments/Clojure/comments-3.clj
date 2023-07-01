(+ 1 (comment "foo") 3)  ;; Throws an exception, because it tries to add nil to an integer
(+ 1 #_"foo" 3)          ;; Returns 4
