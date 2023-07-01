(let [panel (proxy [javax.swing.JPanel] []
              (paintComponent [g]
                (proxy-super paintComponent g)
                (.setStroke g (java.awt.BasicStroke. 2))
                (.setRenderingHint g java.awt.RenderingHints/KEY_ANTIALIASING
                                   java.awt.RenderingHints/VALUE_ANTIALIAS_ON)
                (let [[a b] [0 (/ 1 Math/PI)]
                      [w h] [(.getWidth this) (.getHeight this)]
                      [cx cy] [(/ w 2.0) (/ h 2.0)]
                      margin 16
                      [rotations point-n] [3 (quot (min w h) 2)]
                      [ring-n line-n] [6 12]
                      scale (/ (- (min w h) (* 2 margin)) (* 2.0 ring-n))]
                  ;; Grid
                  (.setColor g (java.awt.Color. 0xEEEEEE))
                  (doseq [i (range 1 (inc ring-n))]
                    (let [[posx posy] [(- cx (* i scale)) (- cy (* i scale))]]
                      (.drawOval g posx posy (* 2 i scale) (* 2 i scale))))
                  (dotimes [i line-n]
                    (let [theta (* 2 Math/PI (/ i (double line-n)))
                          [x y] [(+ cx (* scale ring-n (Math/cos theta)))
                                 (+ cy (* scale ring-n (Math/sin theta)))]]
                      (.drawLine g cx cy x y)))
                  ;; Spiral
                  (.setColor g (java.awt.Color. 0x202020))
                  (loop [i 0 [x y] [(+ cx (* a scale)) cy]]
                    (let [p (/ (inc i) (double point-n))
                          theta (* rotations 2 Math/PI p)
                          r (* scale (+ a (* b theta)))
                          [x1 y1] [(+ cx (* r (Math/cos theta)))
                                   (- cy (* r (Math/sin theta)))]]
                      (.drawLine g x y x1 y1)
                      (when (< i (dec point-n)) (recur (inc i) [x1 y1])))))))]
  (doto (javax.swing.JFrame.)
    (.add (doto panel
            (.setPreferredSize (java.awt.Dimension. 640 640))
            (.setBackground java.awt.Color/white))
          java.awt.BorderLayout/CENTER)
    (.pack)
    (.setVisible true)))
