      SUBROUTINE EVALFG (N, X, F, G)
       IMPLICIT NONE
       INTEGER N
       DOUBLE PRECISION X(N), F, G(N)
       F = (X(1) - 1.D0)**2 * EXP(-X(2)**2) +
     $      X(2) * (X(2) + 2.D0) * EXP(-2.D0 * X(1)**2)
       G(1) = 2.D0 * (X(1) - 1.D0) * EXP(-X(2)**2) - 4.D0 * X(1) *
     $        EXP(-2.D0 * X(1)**2) * X(2) * (X(2) + 2.D0)
       G(2) = (-2.D0 * (X(1) - 1.D0)**2 * X(2) * EXP(-X(2)**2)) +
     $        EXP(-2.D0 * X(1)**2) * (X(2) + 2.D0) +
     $        EXP(-2.D0 * X(1)**2) * X(2)
       RETURN
      END

*-----------------------------------------------------------------------
* gd - Gradient descent
* G must be set correctly at the initial point X.
*
*___Name______Type________In/Out___Description_________________________
*   N         Integer     In       Number of Variables.
*   X(N)      Double      Both     Variables
*   G(N)      Double      Both     Gradient
*   TOL       Double      In       Relative convergence tolerance
*   IFLAG     Integer     Out      Reverse Communication Flag
*                                    on output:  0  done
*                                                1  compute G and call again
*-----------------------------------------------------------------------
      SUBROUTINE GD (N, X, G, TOL, IFLAG)
       IMPLICIT NONE
       INTEGER N, IFLAG
       DOUBLE PRECISION X(N), G(N), TOL
       DOUBLE PRECISION ETA
       PARAMETER (ETA = 0.3D0)     ! Learning rate
       INTEGER I
       DOUBLE PRECISION GNORM      ! norm of gradient

       GNORM = 0.D0                ! convergence test
       DO I = 1, N
         GNORM = GNORM + G(I)**2
       END DO
       GNORM = SQRT(GNORM)
       IF (GNORM < TOL) THEN
         IFLAG = 0
         RETURN                     ! success
       END IF

       DO I = 1, N                 ! take step
         X(I) = X(I) - ETA * G(I)
       END DO
       IFLAG = 1
       RETURN                      ! let main program evaluate G
      END  ! of gd

      PROGRAM GDDEMO
       IMPLICIT NONE
       INTEGER N
       PARAMETER (N = 2)
       INTEGER ITER, J, IFLAG
       DOUBLE PRECISION X(N), F, G(N), TOL

       X(1) = -0.1D0         ! initial values
       X(2) = -1.0D0
       TOL = 1.D-15
       CALL EVALFG (N, X, F, G)
       IFLAG = 0
       DO J = 1, 1 000 000
         CALL GD (N, X, G, TOL, IFLAG)
         IF (IFLAG .EQ. 1) THEN
           CALL EVALFG (N, X, F, G)
         ELSE
           ITER = J
           GO TO 50
         END IF
       END DO
       STOP 'too many iterations!'

  50   PRINT '(A, I7, A, F19.15, A, F19.15, A, F19.15)',
     $          'After ', ITER, ' steps, found minimum at x=',
     $           X(1), ' y=', X(2), ' of f=', F
       STOP 'program complete'
      END
