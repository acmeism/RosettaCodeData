user=> (def empty-queue clojure.lang.PersistentQueue/EMPTY)
#'user/empty-queue
user=> (def aqueue (atom empty-queue))
#'user/aqueue
; Check if queue is empty
user=> (empty? @aqueue)
true
; As with other Clojure data structures, you can add items using conj and into
user=> (swap! aqueue conj 1)
user=> (swap! aqueue into [2 3 4])
user=> (pprint @aqueue)
<-(1 2 3 4)-<
; You can read the head of the queue with peek
user=> (peek @aqueue)
1
; You can remove the head producing a new queue using pop
user=> (pprint (pop @aqueue))
<-(2 3 4)-<
; pop returns a new queue, the original is still intact
user=> (pprint @aqueue)
<-(1 2 3 4)-<
; you can treat a queue as a sequence
user=> (into [] @aqueue)
[1 2 3 4]
; but remember that using rest or next converts the queue to a seq. Compare:
user=> (-> @aqueue rest (conj 5) pprint)
(5 2 3 4)
; with:
user=> (-> @aqueue pop (conj 5) pprint)
<-(2 3 4 5)-<
