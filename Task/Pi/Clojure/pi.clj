(ns pidigits
  (:gen-class))

(def calc-pi
        ;  integer division rounding downwards to -infinity
  (let [div (fn [x y] (long (Math/floor (/ x y))))

          ; Computations performed after yield clause in Python code
          update-after-yield (fn [[q r t k n l]]
                         (let [nr (* 10 (- r (* n t)))
                               nn (- (div (* 10 (+ (* 3 q) r)) t) (* 10 n))
                               nq (* 10 q)]
                           [nq nr t k nn l]))

          ; Update of else clause in Python code: if (< (- (+ (* 4 q) r) t) (* n t))
          update-else (fn [[q r t k n l]]
                        (let [nr (* (+ (* 2 q) r) l)
                              nn (div (+ (* q 7 k) 2 (* r l)) (* t l))
                              nq (* k q)
                              nt (* l t)
                              nl (+ 2 l)
                              nk (+ 1 k)]
                          [nq nr nt nk nn nl]))

          ; Compute the lazy sequence of pi digits translating the Python code
          pi-from (fn pi-from [[q r t k n l]]
                    (if (< (- (+ (* 4 q) r) t) (* n t))
                      (lazy-seq (cons n (pi-from (update-after-yield [q r t k n l]))))
                      (recur (update-else [q r t k n l]))))]

      ; Use Clojure big numbers to perform the math (avoid integer overflow)
      (pi-from [1N 0N 1N 1N 3N 3N])))

;; Indefinitely Output digits of pi, with 40 characters per line
(doseq [[i q] (map-indexed vector calc-pi)]
  (when (= (mod i 40) 0)
    (println))
  (print q))
