(de montyHall (Keep)
   (let (Prize (rand 1 3)  Choice (rand 1 3))
      (if Keep                    # Keeping the first choice?
         (= Prize Choice)         # Yes: Monty's choice doesn't matter
         (<> Prize Choice) ) ) )  # Else: Win if your first choice was wrong

(prinl
   "Strategy KEEP    -> "
   (let Cnt 0
      (do 10000 (and (montyHall T) (inc 'Cnt)))
      (format Cnt 2) )
   " %" )

(prinl
   "Strategy SWITCH  -> "
   (let Cnt 0
      (do 10000 (and (montyHall NIL) (inc 'Cnt)))
      (format Cnt 2) )
   " %" )
