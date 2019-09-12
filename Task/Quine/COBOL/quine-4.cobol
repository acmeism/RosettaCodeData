        Author. Tom Dawes-Gamble. (c) 2000
       01 src-lines pic x(768) value
       "        Author. Tom Dawes-Gamble. (c) 2000
      -"01 src-lines pic x(768) value
      -"01 sl redefines src-lines pic x(64) occurs 12 indexed by i.
      -"  Perform varying i from 1 by 1 until i > 2
      -"    Display '       ' sl(i).
      -"  Display '       ' quote sl(1).
      -"  Perform varying i from 2 by 1 until i > 11
      -"    Display '      ' '-' quote sl(i).
      -"  Display '      ' '-' quote '  Stop run.' quote '.'.
      -"  Perform varying i from 3 by 1 until i > 12
      -"    Display '       ' sl(i).
      -"  Stop run.".
       01 sl redefines src-lines pic x(64) occurs 12 indexed by i.
         Perform varying i from 1 by 1 until i > 2
           Display '       ' sl(i).
         Display '       ' quote sl(1).
         Perform varying i from 2 by 1 until i > 11
           Display '      ' '-' quote sl(i).
         Display '      ' '-' quote '  Stop run.' quote '.'.
         Perform varying i from 3 by 1 until i > 12
           Display '       ' sl(i).
         Stop run.
