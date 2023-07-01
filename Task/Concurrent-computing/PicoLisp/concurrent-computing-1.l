(for (N . Str) '("Enjoy" "Rosetta" "Code")
   (task (- N) (rand 1000 4000)              # Random start time 1 .. 4 sec
      Str Str                                # Closure with string value
      (println Str)                          # Task body: Print the string
      (task @) ) )                           # and stop the task
