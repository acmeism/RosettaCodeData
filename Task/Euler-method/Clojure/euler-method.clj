(ns newton-cooling
  (:gen-class))

(defn euler [f y0 a b h]
  "Euler's Method.
  Approximates y(time) in y'(time)=f(time,y) with y(a)=y0 and t=a..b and the step size h."
  (loop [t a
         y y0
         result []]
    (if (<= t b)
        (recur (+ t h) (+ y (* (f (+ t h) y) h)) (conj result [(double t) (double y)]))
        result)))

(defn newton-coolling [t temp]
  "Newton's cooling law, f(t,T) = -0.07*(T-20)"
  (* -0.07 (- temp 20)))

; Run for case h = 10
(println "Example output")
(doseq [q (euler newton-coolling 100 0 100 10)]
  (println (apply format "%.3f %.3f" q)))
