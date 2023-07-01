       identification division.
       program-id. sample.

       data division.
       working-storage section.
       01 progname pic x(16).

       procedure division.
       sample-main.

       display 0 upon argument-number
       accept progname from argument-value
       display "argument-value zero :" progname ":"

       display "function module-id  :" function module-id ":"

       goback.
       end program sample.
