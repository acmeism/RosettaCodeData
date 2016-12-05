(import
  [math [sqrt]]
  [random [choice]]
  [matplotlib.pyplot :as plt])

(setv possible-points (list-comp (, x y)
  [x (range -15 16) y (range -15 16)]
  (<= 10 (sqrt (+ (** x 2) (** y 2))) 15)))

(setv [xs ys] (apply zip (list-comp (choice possible-points) [_ (range 100)])))
  ; We can't use random.sample because that samples without replacement.
(plt.plot xs ys "bo")
(plt.show)
