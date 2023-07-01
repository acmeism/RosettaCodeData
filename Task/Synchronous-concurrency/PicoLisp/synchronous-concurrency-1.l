# Reading task (synchronous)
(task (open "input.txt")
   (let Fd @
      (if (in Fd (line T))             # More lines?
         (udp "localhost" 4444 @)      # Yes: Send next line
         (task (port T 4445)           # Else install handler
            (prinl (udp @) " lines")   # to receive and print count
            (task (close @)) )
         (udp "localhost" 4444 T)      # Send 'T' for "Done"
         (task (close Fd)) ) ) )       # Stop the task

# Printing task (asynchronous)
(sigio (setq "Sock" (port T 4444))
   (job '((Cnt . 0))
      (let? X (udp "Sock")
         (if (=T X)                    # Done?
            (prog
               (udp "localhost" 4445 Cnt) # Yes: Send count
               (sigio (close "Sock")) )   # and stop the task
            (println X)                # Else print line to stdout
            (inc 'Cnt) ) ) ) )         # and increment count
