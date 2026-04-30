       identification division.
       program-id. foreign.

       data division.
       working-storage section.
       01 hello.
          05 value z"Hello, world".
       01 duplicate    usage pointer.
       01 buffer       pic x(16) based.
       01 storage      pic x(16).

       procedure division.
       call "strdup" using hello returning duplicate
           on exception
               display "error calling strdup" upon syserr
       end-call
       if duplicate equal null then
           display "strdup returned null" upon syserr
       else
           set address of buffer to duplicate
           string buffer delimited by low-value into storage
           display function trim(storage)
           call "free" using by value duplicate
               on exception
                   display "error calling free" upon syserr
       end-if
       goback.
