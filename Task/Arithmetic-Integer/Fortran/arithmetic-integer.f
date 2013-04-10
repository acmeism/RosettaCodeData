 INTEGER A, B
 PRINT *, 'Type in two integer numbers separated by white space',
+         ' and press ENTER'
 READ *, A, B
 PRINT *, '   A + B = ', (A + B)
 PRINT *, '   A - B = ', (A - B)
 PRINT *, '   A * B = ', (A * B)
 PRINT *, '   A / B = ', (A / B)
 PRINT *, 'MOD(A,B) = ', MOD(A,B)
 PRINT *
 PRINT *, 'Even though you did not ask, ',
+         'exponentiation is an intrinsic op in Fortran, so...'
 PRINT *, '  A ** B = ', (A ** B)
 END
