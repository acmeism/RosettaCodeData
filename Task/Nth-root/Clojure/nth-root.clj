(ns test-project-intellij.core
  (:gen-class))

;; define abs & power to avoid needing to bring in the clojure Math library
(defn abs [x]
  " Absolute value"
  (if (< x 0) (- x) x))

(defn power [x n]
  " x to power n, where n = 0, 1, 2, ... "
  (apply * (repeat n x)))

(defn calc-delta [A x n]
  " nth rooth algorithm delta calculation "
  (/ (- (/ A (power x (- n 1))) x) n))

(defn nth-root
  " nth root of algorithm: A = numer, n = root"
  ([A n] (nth-root A n 0.5 1.0))  ; Takes only two arguments A, n and calls version which takes A, n, guess-prev, guess-current
  ([A n guess-prev guess-current] ; version take takes in four arguments (A, n, guess-prev, guess-current)
   (if (< (abs (- guess-prev guess-current)) 1e-6)
     guess-current
     (recur A n guess-current (+ guess-current (calc-delta A guess-current n)))))) ; iterate answer using tail recursion
