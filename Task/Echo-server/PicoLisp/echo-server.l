(setq Port (port 12321))

(loop
   (setq Sock (listen Port))           # Listen
   (NIL (fork) (close Port))           # Accepted
   (close Sock) )                      # Parent: Close socket and continue

# Child:
(prinl (stamp) " -- (Pid " *Pid ") Client connected from " *Adr)

(in Sock
   (until (eof)                        # Echo lines
      (out Sock (prinl (line))) ) )

(prinl (stamp) " -- (Pid " *Pid ") Client disconnected")
(bye)                                  # Terminate child
