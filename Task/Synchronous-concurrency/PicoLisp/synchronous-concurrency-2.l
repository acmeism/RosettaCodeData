(co 'unit1
   (yield)                       # Allow 'unit2' to start
   (in "input.txt"               # Read the file
      (while (line T)            # Send each line
         (yield @ 'unit2) ) )    # to 'unit2'
   (prinl
      (yield NIL 'unit2)         # Send 'NIL' for "Done", receive count
      " lines" ) )

(co 'unit2
   (let Cnt 0                    # Init counter
      (while (yield NIL 'unit1)  # Receive line
         (println @)             # Print it
         (inc 'Cnt) )            # Increment count
      (yield Cnt 'unit1) ) )     # Send count to 'unit1'
