(call 'mkfifo "in" "out")              # Create pipes

(zero *Cnt)                            # Initialize byte counter

(unless (fork)                         # Handle "out" pipe
   (loop
      (out "out"
         (sync)
         (tell)
         (prinl *Cnt) ) ) )

(unless (fork)                         # Handle "in" pipe
   (let P (open "in")
      (loop
         (in P                         # Open twice, to avoid broken pipes
            (while (rd 1)                 # (works on Linux, perhaps not POSIX)
               (tell 'inc ''*Cnt) ) ) ) ) )

(push '*Bye '(call 'rm "in" "out"))    # Remove pipes upon exit
(wait)                                 # (Terminate with Ctrl-C)
