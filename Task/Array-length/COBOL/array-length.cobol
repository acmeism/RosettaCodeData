       identification division.
       program-id. array-length.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 table-one.
          05 str-field pic x(7) occurs 0 to 5 depending on t1.

       77 t1           pic 99.

       procedure division.
       array-length-main.
       perform initialize-table
       perform display-table-info
       goback.

       initialize-table.
           move 1 to t1
           move "apples" to str-field(t1)

           add 1 to t1
           move "oranges" to str-field(t1).

      *> add an extra element and then retract table size
           add 1 to t1
           move "bananas" to str-field(t1).
           subtract 1 from t1
       .

       display-table-info.
           display "Elements: " t1 ", using " length(table-one) " bytes"
           display table-one
       .

       end program array-length.
