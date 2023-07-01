       identification division.
       program-id. hostname.

       data division.
       working-storage section.
       01 hostname pic x(256).
       01 nullpos  pic 999 value 1.

       procedure division.
       call "gethostname" using hostname by value length of hostname
       string hostname delimited by low-value into hostname
           with pointer nullpos
       display "Host: " hostname(1 : nullpos - 1)
       goback.
       end program hostname.
