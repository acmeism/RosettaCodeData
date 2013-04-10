(for Str '("Enjoy" "Rosetta" "Code")
   (let N (rand 1000 4000)                   # Randomize
      (unless (fork)                         # Create child process
         (wait N)                            # Wait 1 .. 4 sec
         (println Str)                       # Print string
         (bye) ) ) )                         # Terminate child process
