       identification division.
       program-id. pan-test.
       data division.
       working-storage section.
       1 text-string pic x(80).
       1 len binary pic 9(4).
       1 trailing-spaces binary pic 9(4).
       1 pangram-flag pic x value "n".
        88 is-not-pangram value "n".
        88 is-pangram value "y".
       procedure division.
       begin.
           display "Enter text string:"
           accept text-string
           set is-not-pangram to true
           initialize trailing-spaces len
           inspect function reverse (text-string)
           tallying trailing-spaces for leading space
               len for characters after space
           call "pangram" using pangram-flag len text-string
           cancel "pangram"
           if is-pangram
               display "is a pangram"
           else
               display "is not a pangram"
           end-if
           stop run
           .
       end program pan-test.

       identification division.
       program-id. pangram.
       data division.
       1 lc-alphabet pic x(26) value "abcdefghijklmnopqrstuvwxyz".
       linkage section.
       1 pangram-flag pic x.
        88 is-not-pangram value "n".
        88 is-pangram value "y".
       1 len binary pic 9(4).
       1 text-string pic x(80).
       procedure division using pangram-flag len text-string.
       begin.
           inspect lc-alphabet converting
               function lower-case (text-string (1:len))
               to space
           if lc-alphabet = space
               set is-pangram to true
           end-if
           exit program
           .
       end program pangram.
