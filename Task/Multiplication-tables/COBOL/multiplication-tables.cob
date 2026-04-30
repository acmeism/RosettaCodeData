       identification division.
       program-id. multiplication-table.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 multiplication.
          05 rows occurs 12 times.
             10 colm occurs 12 times.
                15 num    pic 999.
       77 cand pic 99.
       77 ier  pic 99.
       77 ind  pic z9.
       77 show pic zz9.

       procedure division.
       sample-main.
       perform varying cand from 1 by 1 until cand greater than 12
                  after ier from 1 by 1 until ier greater than 12
           multiply cand by ier giving num(cand, ier)
       end-perform

       perform varying cand from 1 by 1 until cand greater than 12
           move cand to ind
           display "x " ind "| " with no advancing
           perform varying ier from 1 by 1 until ier greater than 12
               if ier greater than or equal to cand then
                   move num(cand, ier) to show
                   display show with no advancing
                   if ier equal to 12 then
                       display "|"
                   else
                       display space with no advancing
                   end-if
               else
                   display "    " with no advancing
               end-if
           end-perform
       end-perform

       goback.
       end program multiplication-table.
