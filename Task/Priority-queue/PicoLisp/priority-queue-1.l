# Insert item into priority queue
(de insertPQ (Queue Prio Item)
   (idx Queue (cons Prio Item) T) )

# Remove and return top item from priority queue
(de removePQ (Queue)
   (cdar (idx Queue (peekPQ Queue) NIL)) )

# Find top element in priority queue
(de peekPQ (Queue)
   (let V (val Queue)
      (while (cadr V)
         (setq V @) )
      (car V) ) )

# Merge second queue into first
(de mergePQ (Queue1 Queue2)
   (balance Queue1 (sort (conc (idx Queue1) (idx Queue2)))) )
