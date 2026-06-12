C DIAGONAL-DIAGONAL MATRIX IN FORTRAN 77

       PROGRAM PROG

       DIMENSION A(100, 100)

       N = 7

       A = 0.
       DO 10 I = 1, N
       A(I, I) = 1.
  10   A(I, N - I + 1) = 1.

       DO 20 I = 1, N
  20   PRINT *, (A(I, J), J=1,N)

       END
