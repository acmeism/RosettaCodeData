(unless (fork)                         # In child process
   (println *Pid)                      # Print the child's PID
   (bye) )                             # and terminate
