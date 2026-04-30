       identification division.
       program-id. long-mul.
       data division.
       replace ==ij-lim== by ==7== ==ir-lim== by ==14==.
       working-storage section.
       1 input-string pic x(26) value "18,446,744,073,709,551,616".
       1 a-table.
        2 a pic 999 occurs ij-lim.
       1 b-table.
        2 b pic 999 occurs ij-lim.
       1 ir-table value all "0".
        2 occurs ij-lim.
         3 ir pic 999 occurs ir-lim.
       1 s-table value all "0".
        2 s pic 999 occurs ir-lim.
       1 display.
        2 temp-result pic 9(6) value 0.
        2 carry pic 999 value 0.
        2 remain pic 999 value 0.
       1 binary.
        2 i pic 9(4) value 0.
        2 j pic 9(4) value 0.
        2 k pic 9(4) value 0.
       procedure division.
       begin.
           move 1 to j
           perform varying i from 1 by 1 until i > ij-lim
               unstring input-string delimited ","
                   into a (i) with pointer j
           end-perform
           move a-table to b-table
           perform intermediate-calc
           perform sum-ir
           perform display-result
       stop run
       .

       intermediate-calc.
           perform varying i from ij-lim by -1 until i < 1
               move 0 to carry
               perform varying j from ij-lim by -1 until j < 1
                   compute temp-result = a (i) * b (j) + carry
                   divide temp-result by 1000 giving carry
                       remainder remain
                   compute k = i + j
                   move remain to ir (i k)
               end-perform
               subtract 1 from k
               move carry to ir (i k)
           end-perform
           .

       sum-ir.
           move 0 to carry
           perform varying k from ir-lim by -1 until k < 1
               move carry to temp-result
               perform varying i from ij-lim by -1 until i < 1
                   compute temp-result = temp-result + ir (i k)
               end-perform
               divide temp-result by 1000 giving carry
                   remainder remain
               move remain to s (k)
           end-perform
           .

       display-result.
           display "   " input-string
           display " * " input-string
           display " = " with no advancing
           perform varying k from 1 by 1
           until k > ir-lim or s (k) not = 0
           end-perform
           if s (k) < 100
               move 1 to i
               inspect s (k) tallying i for leading "0"
               display s (k) (i:) "," with no advancing
               add 1 to k
           end-if
           perform varying k from k by 1 until k > ir-lim
               display s (k) with no advancing
               if k < ir-lim
                   display "," with no advancing
               end-if
           end-perform
           display space
           .

       end program long-mul.
