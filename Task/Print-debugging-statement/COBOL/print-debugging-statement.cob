gcobol*>
      *> steptrace.cob
      *> Tectonics: cobc -xj -fdebugging-line -ftraceall steptrace.cob
      *>   export COB_SET_TRACE=Y
      *>
       identification division.
       program-id. steptrace.

       data division.
       working-storage section.

       procedure division.
       steptrace-main.

       display "explicit line" upon syserr

    >>Ddisplay "debug line" upon syserr

       display "from " FUNCTION MODULE-ID " in " FUNCTION MODULE-SOURCE
       goback.
       end program steptrace.
