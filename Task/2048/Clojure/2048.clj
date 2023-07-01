(ns 2048
  (:require [clojure.string :as str]))

;Preferences
(def textures {:wall      "----+"
               :cell      "%4s|"
               :cell-edge "|"
               :wall-edge "+"})

(def directions {:w :up
                 :s :down
                 :a :left
                 :d :right})

(def field-size {:y 4 :x 4})

;Output
(defn cells->str [line]
  (str (:cell-edge textures)
       (str/join (map (partial format (:cell textures)) line))
       "\n"))

(defn walls->str [width]
  (str (:wall-edge textures)
       (str/join (repeat width (:wall textures)))
       "\n"))

(defn field->str [field]
  (let [height (count field)
        width (count (first field))]
    (str (str/join (interleave (repeat height (walls->str width))
                               (map cells->str field)))
         (walls->str width))))

;Misc
(defn handle-input []
  (let [input (read)
        try-dir ((keyword input) directions)]
    (if try-dir try-dir (recur))))

(defn get-columns [field]
  (vec (for [x (range (count (first field)))]
         (vec (for [y (range (count field))]
                (get-in field [y x]))))))

(defn reverse-lines [field]
  (mapv #(vec (reverse %)) field))

(defn padding [coll n sym]
  (vec (concat coll (repeat n sym))))

(defn find-empties [field]
  (remove
    nil?
    (for [y (range (count field))
          x (range (count (nth field y)))]
      (when (= (get-in field [y x]) \space) [y x]))))

(defn random-add [field]
  (let [empties (vec (find-empties field))]
    (assoc-in field
              (rand-nth empties)
              (rand-nth (conj (vec (repeat 9 2)) 4)))))

(defn win-check [field]
  (= 2048
     (transduce
       (filter number?)
       (completing max)
       0
       (flatten field))))

(defn lose-check [field]
  (empty? (filter (partial = \space) (flatten field))))

(defn create-start-field [y x]
  (->> (vec (repeat y (vec (repeat x \space))))
       (random-add)
       (random-add)))

;Algo
(defn lines-by-dir [back? direction field]
  (case direction
    :left field
    :right (reverse-lines field)
    :down (if back?
            (get-columns (reverse-lines field))
            (reverse-lines (get-columns field)))
    :up (get-columns field)))

(defn shift-line [line]
  (let [len (count line)
        line (vec (filter number? line))
        max-idx (dec (count line))]
    (loop [new [] idx 0]
      (if (> idx max-idx)
          (padding new (- len (count new)) \space)
          (if (= (nth line idx) (get line (inc idx)))
              (recur (conj new (* 2 (nth line idx))) (+ 2 idx))
              (recur (conj new (nth line idx)) (inc idx)))))))

(defn shift-field [direction field]
  (->> (lines-by-dir false direction field)
       (mapv shift-line)
       (lines-by-dir true direction)))

(defn handle-turn [field]
  (let [direction (handle-input)]
    (->> (shift-field direction field)
         (random-add))))

(defn play-2048 []
  (loop [field (create-start-field (:y field-size) (:x field-size))]
    (println (field->str field))
    (cond (win-check field) (println "You win")
          (lose-check field) (println "You lose")
          :default (recur (handle-turn field)))))

(play-2048)
