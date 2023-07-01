(let? Sock (connect "localhost" 12321)
   (out Sock (pr '*Pid))               # Query PID from server
   (println 'PID (in Sock (rd)))       # Receive and print reply
   (out Sock (pr '(* 3 4)))            # Request some calculation
   (println 'Result (in Sock (rd)))    # Print result
   (close Sock) )                      # Close connection to server
