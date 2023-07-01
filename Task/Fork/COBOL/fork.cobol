       identification division.
       program-id. forking.

       data division.
       working-storage section.
       01 pid usage binary-long.

       procedure division.
       display "attempting fork"

       call "fork" returning pid
           on exception
               display "error: no fork linkage" upon syserr
       end-call

       evaluate pid
          when = 0
              display "    child sleeps"
              call "C$SLEEP" using 3
              display "    child task complete"
          when < 0
              display "error: fork result not ok" upon syserr
          when > 0
              display "parent waits for child..."
              call "wait" using by value 0
              display "parental responsibilities fulfilled"
       end-evaluate

       goback.
       end program forking.
