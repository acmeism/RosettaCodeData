(ns small-projects.find-shortest-way
  (:require [clojure.string :as str]))

;Misk functions
(defn cell-empty? [maze coords]
  (= :empty (get-in maze coords)))

(defn wall? [maze coords]
  (= :wall (get-in maze coords)))

(defn track? [maze coords]
  (= :track (get-in maze coords)))

(defn get-neighbours [maze [y x cell]]
  [[y (dec x)] [(inc y) x] [y (inc x)] [(dec y) x]])

(defn get-difference [coll1 filter-coll]
  (filter #(not (contains? filter-coll %)) coll1))

(defn get-empties [maze cell]
      (->> (get-neighbours maze cell)
           (filter (partial cell-empty? maze))))

(defn possible-ways [maze cell filter-coll]
  (-> (get-empties maze cell)
      (get-difference filter-coll)))

(defn replace-cells [maze coords v]
  (if (empty? coords)
    maze
    (recur (assoc-in maze (first coords) v) (rest coords) v)))

;Print and parse functions
(def cell-code->str
  ["  " "  " "  " "  " "· " "╵ " "╴ " "┘ "
   "  " "  " "  " "  " "╶─" "└─" "──" "┴─"
   "  " "  " "  " "  " "╷ " "│ " "┐ " "┤ "
   "  " "  " "  " "  " "┌─" "├─" "┬─" "┼─"
   "  " "  " "  " "  " "■ " "╹ " "╸ " "┛ "
   "  " "  " "  " "  " "╺━" "┗━" "━━" "┻━"
   "  " "  " "  " "  " "╻ " "┃ " "┓ " "┫ "
   "  " "  " "  " "  " "┏━" "┣━" "┳━" "╋━"
   "  "])

(defn get-cell-code [maze coords]
  (let [mode (if (track? maze coords) 1 0)
        check (if (zero? mode) wall? track?)]
    (transduce
      (comp
        (map (partial check maze))
        (keep-indexed (fn [idx test] (when test idx)))
        (map (partial bit-shift-left 1)))
      (completing bit-or)
      (bit-shift-left mode 5)
      (sort (conj (get-neighbours maze coords) coords)))))

(defn code->str [cell-code]
  (nth cell-code->str cell-code))

(defn maze->str-symbols [maze]
  (for [y (range (count maze))]
    (for [x (range (count (nth maze y)))]
      (code->str (get-cell-code maze [y x])))))

(defn maze->str [maze]
  (->> (maze->str-symbols maze)
       (map str/join)
       (str/join "\n")))

(defn parse-pretty-maze [maze-str]
  (->> (str/split-lines maze-str)
       (map (partial take-nth 2))
       (map (partial map #(if (= \space %) :empty :wall)))
       (map vec)
       (vec)))

;Core
(defn find-new-border [maze border old-border]
 (apply conj (map (fn [cell]
                    (zipmap (possible-ways maze cell (conj border old-border))
                            (repeat cell)))
                  (keys border))))

(defn backtrack [visited route]
  (let [cur-cell (get visited (first route))]
    (if (= cur-cell :start)
        route
        (recur visited (conj route cur-cell)))))

(defn breadth-first-search [maze start-cell end-cell]
    (loop [visited {start-cell :start}
           border {start-cell :start}
           old-border {start-cell :start}]
     (if (contains? old-border end-cell)
         (backtrack visited (list end-cell))
         (recur
           (conj visited border)
           (find-new-border maze border old-border)
           border))))

(def maze (parse-pretty-maze maze-str))

(def solved-maze
  (replace-cells maze (breadth-first-search maze [1 1] [19 19]) :track))

(println (maze->str solved-maze))
