;; Point is [x y] tuple
(defn compute-line [pt1 pt2]
  (let [[x1 y1] pt1
        [x2 y2] pt2
        m (/ (- y2 y1) (- x2 x1))]
    {:slope  m
     :offset (- y1 (* m x1))}))

(defn intercept [line1 line2]
  (let [x (/ (- (:offset line1) (:offset line2))
             (- (:slope  line2) (:slope  line1)))]
    {:x x
     :y (+ (* (:slope line1) x)
           (:offset line1))}))
