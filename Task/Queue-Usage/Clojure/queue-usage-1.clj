(def q (make-queue))

(enqueue q 1)
(enqueue q 2)
(enqueue q 3)

(dequeue q) ; 1
(dequeue q) ; 2
(dequeue q) ; 3

(queue-empty? q) ; true
