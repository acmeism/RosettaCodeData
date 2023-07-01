(let Sem (tmp "sem")
   (for U 4  # Create 4 concurrent units
      (unless (fork)
         (ctl Sem
            (prinl "Unit " U " aquired the semaphore")
            (wait 2000)
            (prinl "Unit " U " releasing the semaphore") )
         (bye) ) ) )
