(defn draw-circle [draw-function x0 y0 radius]
  (letfn [(put [x y m]
            (let [x+ (+ x0 x)
                  x- (- x0 x)
                  y+ (+ y0 y)
                  y- (- y0 y)
                  x0y+ (+ x0 y)
                  x0y- (- x0 y)
                  xy0+ (+ y0 x)
                  xy0- (- y0 x)]
              (draw-function x+ y+)
              (draw-function x+ y-)
              (draw-function x- y+)
              (draw-function x- y-)
              (draw-function x0y+ xy0+)
              (draw-function x0y+ xy0-)
              (draw-function x0y- xy0+)
              (draw-function x0y- xy0-)
              (let [[y m] (if (pos? m)
                            [(dec y) (- m (* 8 y))]
                            [y m])]
                (when (<= x y)
                  (put (inc x)
                       y
                       (+ m 4 (* 8 x)))))))]
    (put 0 radius (- 5 (* 4 radius)))))
