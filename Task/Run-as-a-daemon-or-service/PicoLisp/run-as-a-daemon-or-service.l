(unless (fork)
   (out "file.log"
      (println *Pid)    # First write the daemon's PID to the file
      (for N 3600       # Write count for about one hour (if not killed)
         (wait 1000)
         (println N)
         (flush) ) )
   (bye) )              # Child terminates after one hour

(bye)                   # Parent terminates immediately
