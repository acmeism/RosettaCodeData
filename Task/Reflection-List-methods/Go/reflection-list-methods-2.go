; lists all built-in and user-defined functions, including those within variables
(-> (symbols)
    (map eval)
    (filter (comp type-of (= "func"))))

; lists only user-defined functions, including those within variables
(-> (symbols)
    (map eval)
    (filter (comp type-of (= "func")))
    (remove about))
