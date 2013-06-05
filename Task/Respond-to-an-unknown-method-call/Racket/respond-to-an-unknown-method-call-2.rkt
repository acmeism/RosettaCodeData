#lang swindle

(defgeneric (foo x))
(defmethod (no-applicable-method [m (singleton foo)] xs)
  (echo "No method in" m "for" :w xs))
(defmethod (foo [x <integer>]) (echo "It's an integer"))

(foo 1)
;; => It's an integer

(foo "one")
;; => No method in #<generic:foo> for "one"
