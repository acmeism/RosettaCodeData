# Two priority queues
(off Pq1 Pq2)

# Insert into first queue
(insertPQ 'Pq1 3 '(Clear drains))
(insertPQ 'Pq1 4 '(Feed cat))

# Insert into second queue
(insertPQ 'Pq2 5 '(Make tea))
(insertPQ 'Pq2 1 '(Solve RC tasks))
(insertPQ 'Pq2 2 '(Tax return))

# Merge second into first queue
(mergePQ 'Pq1 'Pq2)

# Remove and print all items from first queue
(while Pq1
   (println (removePQ 'Pq1)) )
