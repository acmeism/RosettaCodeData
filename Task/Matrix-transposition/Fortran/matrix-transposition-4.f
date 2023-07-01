      DIMENSION A(3,5),B(5,3),C(5,3)
      EQUIVALENCE (A,C)	!Occupy the same storage.
      DATA A/
     1     1, 2, 3, 4, 5,
     2     6, 7, 8, 9,10,
     3    11,12,13,14,15/	!Supplies values in storage order.

      WRITE (6,*) "Three rows of five values:"
      WRITE (6,1) A	!This shows values in storage order.
      WRITE (6,*) "...written as C(row,column):"
      WRITE (6,2) ((C(I,J),J = 1,3),I = 1,5)
      WRITE (6,*) "... written as A(row,column):"
      WRITE (6,1) ((A(I,J),J = 1,5),I = 1,3)

      WRITE (6,*)
      WRITE (6,*) "B = Transpose(A)"
      DO 10 I = 1,3
        DO 10 J = 1,5
   10     B(J,I) = A(I,J)

      WRITE (6,*) "Five rows of three values:"
      WRITE (6,2) B
      WRITE (6,*) "... written as B(row,column):"
      WRITE (6,2) ((B(I,J),J = 1,3),I = 1,5)

    1 FORMAT (5F6.1)	!Five values per line.
    2 FORMAT (3F6.1)	!Three values per line.
      END
