(import '[java.util Date])
(import '[clojure.lang Reflector])

(def date1 (Date.))
(def date2 (Date.))
(def method "equals")

;; Two ways of invoking method "equals" on object date1
;; using date2 as argument

;; Way 1 - Using Reflector class
;; NOTE: The argument date2 is passed inside an array
(Reflector/invokeMethod date1 method (object-array [date2]))

;; Way 2 - Using eval
;; Eval runs any piece of valid Clojure code
;; So first we construct a piece of code to do what we want (where method name is inserted dynamically),
;; then we run the code using eval
(eval `(. date1 ~(symbol method) date2))
