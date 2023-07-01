> (define MA
    (Markov-algorithm
     (->  "A" "apple")
     (->  "B" "bag")
     (->. "S" "shop")
     (->  "T" "the")
     (->  "the shop" "my brother")
     (->. "a never used" "terminating rule")))

> (MA "I bought a B of As from T S.")
"I bought a bag of apples from T shop."
