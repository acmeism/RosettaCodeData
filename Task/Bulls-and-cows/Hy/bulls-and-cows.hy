(import random)

(def +size+ 4)
(def +digits+ "123456789")
(def +secret+ (random.sample +digits+ +size+))

(while True
  (while True
    (setv guess (list (distinct (raw-input "Enter a guess: "))))
    (when (and
        (= (len guess) +size+)
        (all (map (fn [c] (in c +digits+)) guess)))
      (break))
    (print "Malformed guess; try again"))
  (setv bulls 0)
  (setv cows 0)
  (for [i (range +size+)] (cond
    [(= (get guess i) (get +secret+ i)) (setv bulls (inc bulls))]
    [(in (get guess i) +secret+) (setv cows (inc cows))]))
  (when (= bulls +size+)
    (break))
  (print (.format "{} bull{}, {} cows"
    bulls (if (= bulls 1) "" "s")
    cows (if (= cows 1) "" "s"))))

(print "A winner is you!")
