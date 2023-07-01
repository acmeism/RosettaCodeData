;; They are indistinguishable in Clojure, and you can even override a built in one

;; Using built-in addition

(+ 5 5); => 10

;; Using custom defined addition

(defn ? [a b]
  "Returns the sum of two numbers"
  (+ a b))

(? 5 5); => 10

;; Overriding a built in function is possible but not recommended

(defn * [a b] ;; Redefining the multiplication operator
  "Returns the sum of two numbers"
  (+ a b))

(* 5 5); => 10
