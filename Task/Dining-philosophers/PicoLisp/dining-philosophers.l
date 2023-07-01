(de dining (Name State)
   (loop
      (prinl Name ": " State)
      (state 'State                       # Dispatch according to state
         (thinking 'hungry)               # If thinking, get hungry
         (hungry                          # If hungry, grab random fork
            (if (rand T)
               (and (acquire leftFork) 'leftFork)
               (and (acquire rightFork) 'rightFork) ) )
         (hungry 'hungry                  # Failed, stay hungry for a while
            (wait (rand 1000 3000)) )
         (leftFork                        # If holding left fork, try right one
            (and (acquire rightFork) 'eating)
            (wait 2000) )                 # then eat for 2 seconds
         (rightFork                       # If holding right fork, try left one
            (and (acquire leftFork) 'eating)
            (wait 2000) )                 # then eat for 2 seconds
         ((leftFork rightFork) 'hungry    # Otherwise, go back to hungry,
            (release (val State))         # release left or right fork
            (wait (rand 1000 3000)) )     # and stay hungry
         (eating 'thinking             # After eating, resume thinking
            (release leftFork)
            (release rightFork)
            (wait 6000) ) ) ) )           # for 6 seconds

(setq *Philosophers
   (maplist
      '((Phils Forks)
         (let (leftFork (tmp (car Forks))  rightFork (tmp (cadr Forks)))
            (or
               (fork)  # Parent: Collect child process IDs
               (dining (car Phils) 'hungry) ) ) )  # Initially hungry
      '("Aristotle" "Kant" "Spinoza" "Marx" "Russell")
      '("ForkA" "ForkB" "ForkC" "ForkD" "ForkE" .) ) )

(push '*Bye '(mapc kill *Philosophers))  # Terminate all upon exit
