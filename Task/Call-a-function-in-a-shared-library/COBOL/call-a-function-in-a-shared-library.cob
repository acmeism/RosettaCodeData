       identification division.
       program-id. callsym.

       data division.
       working-storage section.
       01 handle usage pointer.
       01 addr   usage program-pointer.

       procedure division.
       call "dlopen" using
           by reference null
           by value 1
           returning handle
           on exception
               display function exception-statement upon syserr
               goback
       end-call
       if handle equal null then
           display function module-id ": error getting dlopen handle"
             upon syserr
           goback
       end-if

       call "dlsym" using
           by value handle
           by content z"perror"
           returning addr
       end-call
       if addr equal null then
           display function module-id ": error getting perror symbol"
              upon syserr
       else
           call addr returning omitted
       end-if

       goback.
       end program callsym.
