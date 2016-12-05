      identification division.
       program-id. string-append.

       data division.
       working-storage section.
       01 some-string.
          05 elements pic x occurs 0 to 80 times depending on limiter.
       01 limiter     usage index value 7.
       01 current     usage index.

       procedure division.
       append-main.

       move "Hello, " to some-string

      *> extend the limit and move using reference modification
       set current to length of some-string
       set limiter up by 5
       move "world" to some-string(current + 1:)
       display some-string

       goback.
       end program string-append.
