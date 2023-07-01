(call 'clear)

(let Width (in '(tput cols) (read))
   (do (in '(tput lines) (read))
      (for B (range 0 7)
         (call 'tput 'setab B)
         (space (/ Width 8)) )
      (prinl) ) )

(call 'tput 'sgr0)   # reset
