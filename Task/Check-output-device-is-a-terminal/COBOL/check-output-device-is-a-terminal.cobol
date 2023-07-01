      *>
      *> istty, check id fd 0 is a tty
      *> Tectonics: cobc -xj istty.cob
      *>            echo "test" | ./istty
      *>
       identification division.
       program-id. istty.

       data division.
       working-storage section.
       01 rc usage binary-long.

       procedure division.
       sample-main.

       call "isatty" using by value 0 returning rc
       display "fd 0 tty: " rc

       call "isatty" using by value 1 returning rc
       display "fd 1 tty: " rc upon syserr

       call "isatty" using by value 2 returning rc
       display "fd 2 tty: " rc

       goback.
       end program istty.
