user=> (use 'clojure.data.priority-map)

; priority-map can be used as a priority queue
user=> (def p (priority-map "Clear drains" 3, "Feed cat" 4, "Make tea" 5, "Solve RC tasks" 1))
#'user/p
user=> p
{"Solve RC tasks" 1, "Clear drains" 3, "Feed cat" 4, "Make tea" 5}

; You can use assoc or conj to add items
user=> (assoc p "Tax return" 2)
{"Solve RC tasks" 1, "Tax return" 2, "Clear drains" 3, "Feed cat" 4, "Make tea" 5}

; peek to get first item, pop to give you back the priority-map with the first item removed
user=> (peek p)
["Solve RC tasks" 1]

; Merge priority-maps together
user=> (into p [["Wax Car" 4]["Paint Fence" 1]["Sand Floor" 3]])
{"Solve RC tasks" 1, "Paint Fence" 1, "Clear drains" 3, "Sand Floor" 3, "Wax Car" 4, "Feed cat" 4, "Make tea" 5}
