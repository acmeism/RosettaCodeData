       identification division.
       program-id. array-concat.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 table-one.
          05 int-field pic 999 occurs 0 to 5 depending on t1.
       01 table-two.
          05 int-field pic 9(4) occurs 0 to 10 depending on t2.

       77 t1           pic 99.
       77 t2           pic 99.

       77 show         pic z(4).

       procedure division.
       array-concat-main.
       perform initialize-tables
       perform concatenate-tables
       perform display-result
       goback.

       initialize-tables.
           move 4 to t1
           perform varying tally from 1 by 1 until tally > t1
               compute int-field of table-one(tally) = tally * 3
           end-perform

           move 3 to t2
           perform varying tally from 1 by 1 until tally > t2
               compute int-field of table-two(tally) = tally * 6
           end-perform
       .

       concatenate-tables.
           perform varying tally from 1 by 1 until tally > t1
               add 1 to t2
               move int-field of table-one(tally)
                 to int-field of table-two(t2)
           end-perform
       .

       display-result.
           perform varying tally from 1 by 1 until tally = t2
               move int-field of table-two(tally) to show
               display trim(show) ", " with no advancing
           end-perform
           move int-field of table-two(tally) to show
           display trim(show)
       .

       end program array-concat.
