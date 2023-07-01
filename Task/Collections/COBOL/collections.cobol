       identification division.
       program-id. collections.

       data division.
       working-storage section.
       01 sample-table.
          05 sample-record occurs 1 to 3 times depending on the-index.
             10 sample-alpha   pic x(4).
             10 filler         pic x value ":".
             10 sample-number  pic 9(4).
             10 filler         pic x value space.
       77 the-index            usage index.

       procedure division.
       collections-main.

       set the-index to 3
       move 1234 to sample-number(1)
       move "abcd" to sample-alpha(1)

       move "test" to sample-alpha(2)

       move 6789 to sample-number(3)
       move "wxyz" to sample-alpha(3)

       display "sample-table    : " sample-table
       display "sample-number(1): " sample-number(1)
       display "sample-record(2): " sample-record(2)
       display "sample-number(3): " sample-number(3)

      *> abend: out of bounds subscript, -debug turns on bounds check
       set the-index down by 1
       display "sample-table    : " sample-table
       display "sample-number(3): " sample-number(3)

       goback.
       end program collections.
