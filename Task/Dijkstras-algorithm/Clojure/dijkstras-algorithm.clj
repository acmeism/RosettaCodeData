(declare neighbours
         process-neighbour
         prepare-costs
         get-next-node
         unwind-path
         all-shortest-paths)


;; Main algorithm


(defn dijkstra
  "Given two nodes A and B, and graph, finds shortest path from point A to point B.
  Given one node and graph, finds all shortest paths to all other nodes.

  Graph example: {1 {2 7 3 9 6 14}
                  2 {1 7 3 10 4 15}
                  3 {1 9 2 10 4 11 6 2}
                  4 {2 15 3 11 5 6}
                  5 {6 9 4 6}
                  6 {1 14 3 2 5 9}}
                  ^  ^  ^
                  |  |  |
         node label  |  |
    neighbour label---  |
          edge cost------
  From example in Wikipedia: https://en.wikipedia.org/wiki/Dijkstra's_algorithm

  Output example: [20 [1 3 6 5]]
                   ^  ^
                   |  |
  shortest path cost  |
       shortest path---"
  ([a b graph]
   (loop [costs (prepare-costs a graph)
          unvisited (set (keys graph))]
     (let [current-node (get-next-node costs unvisited)
           current-cost (first (costs current-node))]
       (cond (nil? current-node)
             (all-shortest-paths a costs)

             (= current-node b)
             [current-cost (unwind-path a b costs)]

             :else
             (recur (reduce (partial process-neighbour
                                     current-node
                                     current-cost)
                            costs
                            (filter (comp unvisited first)
                                    (neighbours current-node graph costs)))
                    (disj unvisited current-node))))))
  ([a graph] (dijkstra a nil graph)))


;; Implementation details


(defn prepare-costs
  "For given start node A ang graph prepare map of costs to start with
  (assign maximum value for all nodes and zero for starting one).
  Also save info about most advantageous parent.
  Example output: {2 [2147483647 7], 6 [2147483647 14]}
                   ^   ^         ^
                   |   |         |
                node   |         |
               cost-----         |
             parent---------------"
  [start graph]
  (assoc (zipmap (keys graph)
                 (repeat [Integer/MAX_VALUE nil]))
         start [0 start]))


(defn neighbours
  "Get given node's neighbours along with their own costs and costs of corresponding edges.
  Example output is: {1 [7 10] 2 [4 15]}
                      ^  ^  ^
                      |  |  |
   neighbour node label  |  |
        neighbour cost ---  |
             edge cost ------"
  [node graph costs]
  (->> (graph node)
       (map (fn [[neighbour edge-cost]]
              [neighbour [(first (costs neighbour)) edge-cost]]))
       (into {})))


(defn process-neighbour
  [parent
   parent-cost
   costs
   [neighbour [old-cost edge-cost]]]
  (let [new-cost (+ parent-cost edge-cost)]
    (if (< new-cost old-cost)
      (assoc costs
             neighbour
             [new-cost parent])
      costs)))


(defn get-next-node [costs unvisited]
  (->> costs
       (filter (comp unvisited first))
       (sort-by (comp first second))
       ffirst))


(defn unwind-path
  "Restore path from A to B based on costs data"
  [a b costs]
  (letfn [(f [a b costs]
            (when-not (= a b)
              (cons b (f a (second (costs b)) costs))))]
    (cons a (reverse (f a b costs)))))


(defn all-shortest-paths
  "Get shortest paths for all nodes, along with their costs"
  [start costs]
  (let [paths (->> (keys costs)
                   (remove #{start})
                   (map (fn [n] [n (unwind-path start n costs)])))]
    (into (hash-map)
          (map (fn [[n p]]
                 [n [(first (costs n)) p]])
               paths))))


;; Utils


(require '[clojure.pprint :refer [print-table]])


(defn print-solution [solution]
  (print-table
   (map (fn [[node [cost path]]]
          {'node node 'cost cost 'path path})
        solution)))


;; Solutions


;; Task 1. Implement a version of Dijkstra's algorithm that outputs a set of edges depicting the shortest path to each reachable node from an origin.

;; see above


;; Task 2. Run your program with the following directed graph starting at node a.

;; Edges
;;   Start    End  Cost
;;   a        b    7
;;   a        c    9
;;   a        f    14
;;   b        c    10
;;   b        d    15
;;   c        d    11
;;   c        f    2
;;   d        e    6
;;   e        f    9

(def rosetta-graph
  '{a {b 7 c 9 f 14}
    b {c 10 d 15}
    c {d 11 f 2}
    d {e 6}
    e {f 9}
    f {}})

(def task-2-solution
  (dijkstra 'a rosetta-graph))

(print-solution task-2-solution)

;; Output:
;; | node | cost |      path |
;; |------+------+-----------|
;; |    b |    7 |     (a b) |
;; |    c |    9 |     (a c) |
;; |    d |   20 |   (a c d) |
;; |    e |   26 | (a c d e) |
;; |    f |   11 |   (a c f) |


;; Task 3. Write a program which interprets the output from the above and use it to output the shortest path from node a to nodes e and f

(print-solution (select-keys task-2-solution '[e f]))

;; Output:
;; | node | cost |      path |
;; |------+------+-----------|
;; |    e |   26 | (a c d e) |
;; |    f |   11 |   (a c f) |
