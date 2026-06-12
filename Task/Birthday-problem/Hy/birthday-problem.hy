(import
  [numpy :as np]
  [random [randint]])

(defmacro incf (place)
  `(+= ~place 1))

(defn birthday [required &optional [reps 20000] [ndays 365]]
  (setv days (np.zeros (, reps ndays) np.int_))
  (setv qualifying-reps (np.zeros reps np.bool_))
  (setv group-size 1)
  (setv count 0)
  (while True
    ;(print group-size)
    (for [r (range reps)]
      (unless (get qualifying-reps r)
        (setv day (randint 0 (dec ndays)))
        (incf (get days (, r day)))
        (when (= (get days (, r day)) required)
          (setv (get qualifying-reps r) True)
          (incf count))))
    (when (> (/ (float count) reps) .5)
      (break))
    (incf group-size))
  group-size)

(print (birthday 2))
(print (birthday 3))
(print (birthday 4))
(print (birthday 5))
