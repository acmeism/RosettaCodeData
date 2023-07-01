(import
  math [sqrt]
  random [choice]
  matplotlib.pyplot :as plt)

(setv possible-points
  (lfor
    x (range -15 16)
    y (range -15 16)
    :if (<= 10 (sqrt (+ (** x 2) (** y 2))) 15)
	  [x y]))

(setv [xs ys] (zip #* (map (fn [_] (choice possible-points)) (range 100))))
  ; We can't use random.sample because that samples without replacement.
  ; #* is also known as unpack-iterable
(plt.plot xs ys "bo")
(plt.show)
