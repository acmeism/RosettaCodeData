       program-id. test-add.
       environment division.
       configuration section.
       special-names.
           class bin is "0" "1".
       data division.
       working-storage section.
       1 parms.
        2 a-in pic 9999.
        2 b-in pic 9999.
        2 r-out pic 9999.
        2 c-out pic 9.
       procedure division.
           display "Enter 'A' value (4-bits binary): "
               with no advancing
           accept a-in
           if a-in (1:) not bin
               display "A is not binary"
               stop run
           end-if
           display "Enter 'B' value (4-bits binary): "
               with no advancing
           accept b-in
           if b-in (1:) not bin
               display "B is not binary"
               stop run
           end-if
           call "add-4b" using parms
           display "Carry " c-out " result " r-out
           stop run
           .
       end program test-add.

       program-id. add-4b.
       data division.
       working-storage section.
       1 wk binary.
        2 i pic 9(4).
        2 occurs 5.
         3 a-reg pic 9.
         3 b-reg pic 9.
         3 c-reg pic 9.
         3 r-reg pic 9.
        2 a pic 9.
        2 b pic 9.
        2 c pic 9.
        2 a-not pic 9.
        2 b-not pic 9.
        2 c-not pic 9.
        2 ha-1s pic 9.
        2 ha-1c pic 9.
        2 ha-1s-not pic 9.
        2 ha-1c-not pic 9.
        2 ha-2s pic 9.
        2 ha-2c pic 9.
        2 fa-s pic 9.
        2 fa-c pic 9.
       linkage section.
       1 parms.
        2 a-in pic 9999.
        2 b-in pic 9999.
        2 r-out pic 9999.
        2 c-out pic 9.
       procedure division using parms.
           initialize wk
           perform varying i from 1 by 1
           until i > 4
               move a-in (5 - i:1) to a-reg (i)
               move b-in (5 - i:1) to b-reg (i)
           end-perform
           perform simulate-adder varying i from 1 by 1
               until i > 4
           move c-reg (5) to c-out
           perform varying i from 1 by 1
           until i > 4
               move r-reg (i) to r-out (5 - i:1)
           end-perform
           exit program
           .

       simulate-adder section.
           move a-reg (i) to a
           move b-reg (i) to b
           move c-reg (i) to c
           add a -1 giving a-not
           add b -1 giving b-not
           add c -1 giving c-not

           compute ha-1s = function max (
               function min ( a b-not )
               function min ( b a-not ) )
           compute ha-1c = function min ( a b )
           add ha-1s -1 giving ha-1s-not
           add ha-1c -1 giving ha-1c-not

           compute ha-2s = function max (
               function min ( c ha-1s-not )
               function min ( ha-1s c-not ) )
           compute ha-2c = function min ( c ha-1c )

           compute fa-s = ha-2s
           compute fa-c = function max ( ha-1c ha-2c )

           move fa-s to r-reg (i)
           move fa-c to c-reg (i + 1)
           .
       end program add-4b.
