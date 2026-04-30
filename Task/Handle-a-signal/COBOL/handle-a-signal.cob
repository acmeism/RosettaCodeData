       identification division.
       program-id. signals.
       data division.
       working-storage section.
       01 signal-flag  pic 9 external.
          88 signalled value 1.
       01 half-seconds usage binary-long.
       01 start-time   usage binary-c-long.
       01 end-time     usage binary-c-long.
       01 handler      usage program-pointer.
       01 SIGINT       constant as 2.

       procedure division.
       call "gettimeofday" using start-time null
       set handler to entry "handle-sigint"
       call "signal" using by value SIGINT by value handler

       perform until exit
           if signalled then exit perform end-if
           call "CBL_OC_NANOSLEEP" using 500000000
           if signalled then exit perform end-if
           add 1 to half-seconds
           display half-seconds
       end-perform

       call "gettimeofday" using end-time null
       subtract start-time from end-time
       display "Program ran for " end-time " seconds"
       goback.
       end program signals.

       identification division.
       program-id. handle-sigint.
       data division.
       working-storage section.
       01 signal-flag  pic 9 external.

       linkage section.
       01 the-signal   usage binary-long.

       procedure division using by value the-signal returning omitted.
       move 1 to signal-flag
       goback.
       end program handle-sigint.
