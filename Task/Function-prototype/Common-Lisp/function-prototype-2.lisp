;; Rest parameter, for variadic functions: r is a list of arguments.
(a b &rest r)

;; Optional parameter: i defaults to 3, (f 1 2) is same as (f 1 2 3).
(a b &optional (i 3))

;; Keyword parameters: (f 1 2 :c 3 :d 4) is same as (f 1 2 :d 4 :c 3).
(a b &key c d)
