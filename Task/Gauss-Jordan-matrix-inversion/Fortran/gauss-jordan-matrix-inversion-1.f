!-----------------------------------------------------------------------
! gjinv - Invert a matrix, Gauss-Jordan algorithm
! A is destroyed.
!
!___Name_______Type_______________In/Out____Description_________________
!   A(LDA,N)   Real               In        An N by N matrix
!   LDA        Integer            In        Row bound of A
!   N          Integer            In        Order of matrix
!   B(LDB,N)   Real               Out       Inverse of A
!   LDB        Integer            In        Row bound of B
!   IERR       Integer            Out       0 = no errors
!                                           1 = singular matrix
!-----------------------------------------------------------------------
      SUBROUTINE GJINV (A, LDA, N, B, LDB, IERR)
       IMPLICIT NONE
       INTEGER LDA, N, LDB, IERR
       REAL A(LDA,N), B(LDB,N)

       REAL EPS                                  ! machine constant
       PARAMETER (EPS = 1.1920929E-07)
       INTEGER I, J, K, P                        ! local variables
       REAL F, TOL

!-----------------------------------------------------------------------
!             Begin.
!-----------------------------------------------------------------------
       IF (N < 1) THEN            ! Validate.
         IERR = -1
         RETURN
       ELSE IF (N > LDA .OR. N > LDB) THEN
         IERR = -2
         RETURN
       END IF
       IERR = 0

       F = 0.                     ! Frobenius norm of A
       DO J = 1, N
         DO I = 1, N
           F = F + A(I,J)**2
         END DO
       END DO
       F = SQRT(F)
       TOL = F * EPS

       DO J = 1, N                ! Set B to identity matrix.
         DO I = 1, N
           IF (I .EQ. J) THEN
             B(I,J) = 1.
           ELSE
             B(I,J) = 0.
           END IF
         END DO
       END DO

!             Main loop
       DO K = 1, N
         F = ABS(A(K,K))          ! Find pivot.
         P = K
         DO I = K+1, N
           IF (ABS(A(I,K)) > F) THEN
             F = ABS(A(I,K))
             P = I
           END IF
         END DO

         IF (F < TOL) THEN        ! Matrix is singular.
           IERR = 1
           RETURN
         END IF

         IF (P .NE. K) THEN       ! Swap rows.
           DO J = K, N
             F = A(K,J)
             A(K,J) = A(P,J)
             A(P,J) = F
           END DO
           DO J = 1, N
             F = B(K,J)
             B(K,J) = B(P,J)
             B(P,J) = F
           END DO
         END IF

         F = 1. / A(K,K)          ! Scale row so pivot is 1.
         DO J = K, N
           A(K,J) = A(K,J) * F
         END DO
         DO J = 1, N
           B(K,J) = B(K,J) * F
         END DO

         DO 10 I = 1, N           ! Subtract to get zeros.
           IF (I .EQ. K) GO TO 10
           F = A(I,K)
           DO J = K, N
             A(I,J) = A(I,J) - A(K,J) * F
           END DO
           DO J = 1, N
             B(I,J) = B(I,J) - B(K,J) * F
           END DO
  10     CONTINUE
       END DO

       RETURN
      END  ! of gjinv
