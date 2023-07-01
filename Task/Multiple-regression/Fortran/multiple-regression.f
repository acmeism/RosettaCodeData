*-----------------------------------------------------------------------
* MR - multiple regression using the SLATEC library routine DHFTI
*
* Finds the nearest approximation to BETA in the system of linear equations:
*
*              X(j,i) . BETA(i) = Y(j)
* where
*                  1 ... j ... N
*                  1 ... i ... K
* and
*                  K .LE. N
*
* INPUT ARRAYS ARE DESTROYED!
*
*___Name___________Type_______________In/Out____Description_____________
*   X(N,K)         Double precision   In        Predictors
*   Y(N)           Double precision   Both      On input:   N Observations
*                                               On output:  K beta weights
*   N              Integer            In        Number of observations
*   K              Integer            In        Number of predictor variables
*   DWORK(N+2*K)   Double precision   Neither   Workspace
*   IWORK(K)       Integer            Neither   Workspace
*-----------------------------------------------------------------------
      SUBROUTINE MR (X, Y, N, K, DWORK, IWORK)
       IMPLICIT NONE
       INTEGER K, N, IWORK
       DOUBLE PRECISION X, Y, DWORK
       DIMENSION X(N,K), Y(N), DWORK(N+2*K), IWORK(K)

*         local variables
       INTEGER I, J
       DOUBLE PRECISION TAU, TOT

*        maximum of all column sums of magnitudes
       TAU = 0.
       DO J = 1, K
         TOT = 0.
         DO I = 1, N
           TOT = TOT + ABS(X(I,J))
         END DO
         IF (TOT > TAU) TAU = TOT
       END DO
       TAU = TAU * EPSILON(TAU)        ! tolerance argument

*            call function
       CALL DHFTI (X, N, N, K, Y, N, 1, TAU,
     $  J, DWORK(1), DWORK(N+1), DWORK(N+K+1), IWORK)
       IF (J < K) PRINT *, 'mr: solution is rank deficient!'
       RETURN
      END  ! of MR

*-----------------------------------------------------------------------
      PROGRAM t_mr        ! polynomial regression example
       IMPLICIT NONE
       INTEGER N, K
       PARAMETER (N=15, K=3)
       INTEGER IWORK(K), I, J
       DOUBLE PRECISION XIN(N), X(N,K), Y(N), DWORK(N+2*K)

       DATA XIN / 1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68,
     $            1.70, 1.73, 1.75, 1.78, 1.80, 1.83 /
       DATA Y / 52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29,
     $          63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46 /

*              make coefficient matrix
       DO J = 1, K
         DO I = 1, N
           X(I,J) = XIN(I) **(J-1)
         END DO
       END DO

*               solve
       CALL MR (X, Y, N, K, DWORK, IWORK)

*               print result
  10   FORMAT ('beta: ', $)
  20   FORMAT (F12.4, $)
  30   FORMAT ()
       PRINT 10
       DO J = 1, K
         PRINT 20, Y(J)
       END DO
       PRINT 30
       STOP 'program complete'
      END
