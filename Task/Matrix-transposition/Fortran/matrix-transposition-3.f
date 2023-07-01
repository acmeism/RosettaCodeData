   REAL A(3,5), B(5,3)
   DATA ((A(I,J),I=1,3),J=1,5) /1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15/

   DO 10 I = 1, 3
      DO 20 J = 1, 5
         B(J,I) = A(I,J)
20    CONTINUE
10 CONTINUE
