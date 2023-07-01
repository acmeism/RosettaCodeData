(use 'quil.core)

(def w 500)
(def h 400)

(defn setup []
  (background 0))

(defn draw []
  (push-matrix)
  (translate (/ w 2) (/ h 2) 0)
  (rotate-x 0.7)
  (rotate-z 0.5)
  (box 100 150 200)  ; 2x3x4 relative dimensions
  (pop-matrix))

(defsketch main
  :title "cuboid"
  :setup setup
  :size [w h]
  :draw draw
  :renderer :opengl)
