(ns maze.core
  (:require [clojure.set :refer [intersection
                                 select]]
            [clojure.string :as str]))

;; Misc functions
(defn neighborhood
  ([] (neighborhood [0 0]))
  ([coord] (neighborhood coord 1))
  ([[y x] r]
   (let [y-- (- y r) y++ (+ y r)
         x-- (- x r) x++ (+ x r)]
     #{[y++ x] [y-- x] [y x--] [y x++]})))

(defn cell-empty? [maze coords]
  (= :empty (get-in maze coords)))

(defn wall? [maze coords]
  (= :wall (get-in maze coords)))

(defn filter-maze
  ([pred maze coords]
   (select (partial pred maze) (set coords)))
  ([pred maze]
   (filter-maze
     pred
     maze
     (for [y (range (count maze))
           x (range (count (nth maze y)))]
       [y x]))))

(defn create-empty-maze [width height]
  (let [width (inc (* 2 width))
        height (inc (* 2 height))]
    (vec (take height
               (interleave
                 (repeat (vec (take width (repeat :wall))))
                 (repeat (vec (take width (cycle [:wall :empty])))))))))

(defn next-step [possible-steps]
  (rand-nth (vec possible-steps)))

;;Algo
(defn create-random-maze [width height]
  (loop [maze (create-empty-maze width height)
         stack []
         nonvisited (filter-maze cell-empty? maze)
         visited #{}
         coords (next-step nonvisited)]
    (if (empty? nonvisited)
      maze
      (let [nonvisited-neighbors (intersection (neighborhood coords 2) nonvisited)]
        (cond
          (seq nonvisited-neighbors)
          (let [next-coords (next-step nonvisited-neighbors)
                wall-coords (map #(+ %1 (/ (- %2 %1) 2)) coords next-coords)]
            (recur (assoc-in maze wall-coords :empty)
                   (conj stack coords)
                   (disj nonvisited next-coords)
                   (conj visited next-coords)
                   next-coords))

          (seq stack)
          (recur maze (pop stack) nonvisited visited (last stack)))))))

;;Conversion to string
(def cell-code->str
  ["  " "  " "  " "  " "· " "╵ " "╴ " "┘ "
   "  " "  " "  " "  " "╶─" "└─" "──" "┴─"
   "  " "  " "  " "  " "╷ " "│ " "┐ " "┤ "
   "  " "  " "  " "  " "┌─" "├─" "┬─" "┼─"])

(defn cell-code [maze coord]
  (transduce
    (comp
      (map (partial wall? maze))
      (keep-indexed (fn [idx el] (when el idx)))
      (map (partial bit-shift-left 1)))
    (completing bit-or)
    0
    (sort (cons coord (neighborhood coord)))))

(defn cell->str [maze coord]
  (get cell-code->str (cell-code maze coord)))

(defn maze->str [maze]
  (->> (for [y (range (count maze))]
         (for [x (range (count (nth maze y)))]
           (cell->str maze [y x])))
       (map str/join)
       (str/join \newline)))

;;Task
(println (maze->str (create-random-maze 10 10)))
