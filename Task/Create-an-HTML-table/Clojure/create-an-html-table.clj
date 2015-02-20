(ns rosettacode.html-table
  (:use 'hiccup.core))

(defn <tr> [el sq]
  [:tr (map vector (cycle [el]) sq)])

(html
  [:table
    (<tr> :th ["" \X \Y \Z])
    (for [n (range 1 4)]
      (->> #(rand-int 10000) (repeatedly 3) (cons n) (<tr> :td)))])
