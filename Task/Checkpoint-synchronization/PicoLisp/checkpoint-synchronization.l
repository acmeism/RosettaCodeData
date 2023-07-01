(de checkpoints (Projects Workers)
   (for P Projects
      (prinl "Starting project number " P ":")
      (for
         (Staff
            (mapcar
               '((I) (worker (format I) (rand 2 5)))  # Create staff of workers
               (range 1 Workers) )
            Staff                                     # While still busy
            (filter worker Staff) ) )                 # Remove finished workers
      (prinl "Project number " P " is done.") ) )

(de worker (ID Steps)
   (co ID
      (prinl "Worker " ID " has " Steps " steps to do")
      (for N Steps
         (yield ID)
         (prinl "Worker " ID " step " N) )
      NIL ) )
