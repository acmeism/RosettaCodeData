      INTEGER A(3,3)	!An array, regarded as being a matrix.
      DATA A/1,2,3,	!Some initial values.
     2       4,5,6,	!Laid out as if a matrix.
     3       7,8,9/	!But supplied as consecutive elements.

      WRITE (6,*) "Writing A..."
      WRITE (6,1) A	!Using the array order.
    1 FORMAT (3I2)	!After three values, start a new line.

      WRITE (6,*) "Writing A(row,col) down rows and across columns..."
      DO I = 1,3	!Write each row, one after the other.
        WRITE (6,1) (A(I,J), J = 1,3)	!The columns along a row.
      END DO		!Onto the next row.
      END
