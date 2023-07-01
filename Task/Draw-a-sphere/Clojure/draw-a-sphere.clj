(use 'quil.core)

(def w 500)
(def h 400)

(defn setup []
  (background 0))

(defn draw []
  (push-matrix)
  (translate 250 200 0)
  (sphere 100)
  (pop-matrix))

(defsketch main
  :title "sphere"
  :setup setup
  :size [w h]
  :draw draw
  :renderer :opengl)
