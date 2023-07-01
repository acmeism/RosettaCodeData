(task (port 12321)                     # Background server task
   (let? Sock (accept @)
      (unless (fork)                   # Handle request in child process
         (in Sock
            (while (rd)                # Handle requests
               (out Sock
                  (pr (eval @)) ) ) )  # Evaluate and send reply
         (bye) )                       # Exit child process
      (close Sock) ) )                 # Close socket in parent process
