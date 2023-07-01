!             Test matrix inversion
      PROGRAM TINV
       IMPLICIT NONE
       INTEGER I, J, K, N, IERR
       PARAMETER (N = 4)
       REAL AORIG(N,N), A(N,N), B(N,N), C(N,N)
       DATA AORIG / -1., -4.,  7.,  1.,
     $              -2., -1., -8., -2.,
     $               3.,  6.,  9.,  1.,
     $               2.,  2.,  1.,  3. /

  20   FORMAT (F8.3, $)
  30   FORMAT ()

       DO J = 1, N
         DO I = 1, N
           A(I,J) = AORIG(I,J)
         END DO
       END DO

       CALL GJINV (A, N, N, B, N, IERR)
       PRINT *, 'gjinv returns #', IERR
       PRINT 30

       PRINT *, 'matrix:'
       DO I = 1, N
         DO J = 1, N
           PRINT 20, AORIG(I,J)
         END DO
         PRINT 30
       END DO
       PRINT 30

       PRINT *, 'inverse:'
       DO I = 1, N
         DO J = 1, N
           PRINT 20, B(I,J)
         END DO
         PRINT 30
       END DO
       PRINT 30

       DO K = 1, N
         DO J = 1, N
           C(J,K) = 0.
           DO I = 1, N
             C(J,K) = C(J,K) + AORIG(J,I) * B(I,K)
           END DO
         END DO
       END DO

       PRINT *, 'matrix @ inverse:'
       DO I = 1, N
         DO J = 1, N
           PRINT 20, C(I,J)
         END DO
         PRINT 30
       END DO
       PRINT 30

       CALL GJINV (B, N, N, A, N, IERR)
       PRINT *, 'gjinv returns #', IERR
       PRINT 30

       PRINT *, 'inverse of inverse:'
       DO I = 1, N
         DO J = 1, N
           PRINT 20, A(I,J)
         END DO
         PRINT 30
       END DO

      END  ! of test program
