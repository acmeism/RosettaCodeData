(ns c960.core
  (:gen-class)
  (:require [clojure.string :as s]))

;; legal starting rank - unicode chars for rook, knight, bishop, queen, king, bishop, knight, rook
(def starting-rank [\♖ \♘ \♗ \♕ \♔ \♗ \♘ \♖])

(defn bishops-legal?
  "True if Bishops are odd number of indicies apart"
  [rank]
  (odd? (apply - (cons 0 (sort > (keep-indexed #(when (= \♗ %2) %1) rank))))))

(defn king-legal?
  "True if the king is between two rooks"
  [rank]
  (let [king-&-rooks (filter #{\♔ \♖} rank)]
    (and
     (= 3 (count king-&-rooks))
     (= \u2654 (second king-&-rooks)))))


(defn c960
  "Return a legal rank for c960 chess"
  ([] (c960 1))
  ([n]
   (->> #(shuffle starting-rank)
        repeatedly
        (filter #(and (king-legal? %) (bishops-legal? %)))
        (take n)
        (map #(s/join ", " %)))))


(c960)
;; => "♗, ♖, ♔, ♕, ♘, ♘, ♖, ♗"
(c960)
;; => "♖, ♕, ♘, ♔, ♗, ♗, ♘, ♖"
(c960 4)
;; => ("♘, ♖, ♔, ♘, ♗, ♗, ♖, ♕" "♗, ♖, ♔, ♘, ♘, ♕, ♖, ♗" "♘, ♕, ♗, ♖, ♔, ♗, ♘, ♖" "♖, ♔, ♘, ♘, ♕, ♖, ♗, ♗")
