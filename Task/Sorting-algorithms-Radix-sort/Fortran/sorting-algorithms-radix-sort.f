*=======================================================================
* RSORT - sort a list of integers by the Radix Sort algorithm
* Public domain.  This program may be used by any person for any purpose.
* Origin:  Herman Hollerith, 1887
*
*___Name____Type______In/Out____Description_____________________________
*   IX(N)   Integer   Both      Array to be sorted in increasing order
*   IW(N)   Integer   Neither   Workspace
*   N       Integer   In        Length of array
*
* ASSUMPTIONS:  Bits in an INTEGER is an even number.
*               Integers are represented by twos complement.
*
* NOTE THAT:  Radix sorting has an advantage when the input is known
*             to be less than some value, so that only a few bits need
*             to be compared.  This routine looks at all the bits,
*             and is thus slower than Quicksort.
*=======================================================================
      SUBROUTINE RSORT (IX, IW, N)
       IMPLICIT NONE
       INTEGER IX, IW, N
       DIMENSION IX(N), IW(N)

       INTEGER I,                        ! count bits
     $         ILIM,                     ! bits in an integer
     $         J,                        ! count array elements
     $         P1OLD, P0OLD, P1, P0,     ! indices to ones and zeros
     $         SWAP
       LOGICAL ODD                       ! even or odd bit position

*      IF (N < 2) RETURN      ! validate
       J = 0                  ! find bit size of an integer
       J = NOT(J)
       ILIM = 0
       DO I = 1, 32767                 ! much bigger than exists
         J = ISHFT(J, -1)
         IF (.NOT. BTEST(J, 0)) THEN
           ILIM = I
           GO TO 10
         END IF
       END DO
  10   CONTINUE

*=======================================================================
* Alternate between putting data into IW and into IX
*=======================================================================
       P1 = N+1
       P0 = N                ! read from 1, N on first pass thru
       ODD = .FALSE.
       DO I = 0, ILIM-2
         P1OLD = P1
         P0OLD = P0         ! save the value from previous bit
         P1 = N+1
         P0 = 0                 ! start a fresh count for next bit

         IF (ODD) THEN
           DO J = 1, P0OLD, +1             ! copy data from the zeros
             IF ( BTEST(IW(J), I) ) THEN
               P1 = P1 - 1
               IX(P1) = IW(J)
             ELSE
               P0 = P0 + 1
               IX(P0) = IW(J)
             END IF
           END DO
           DO J = N, P1OLD, -1             ! copy data from the ones
             IF ( BTEST(IW(J), I) ) THEN
               P1 = P1 - 1
               IX(P1) = IW(J)
             ELSE
               P0 = P0 + 1
              IX(P0) = IW(J)
             END IF
           END DO

         ELSE
           DO J = 1, P0OLD, +1             ! copy data from the zeros
             IF ( BTEST(IX(J), I) ) THEN
               P1 = P1 - 1
               IW(P1) = IX(J)
              ELSE
               P0 = P0 + 1
               IW(P0) = IX(J)
             END IF
           END DO
           DO J = N, P1OLD, -1            ! copy data from the ones
             IF ( BTEST(IX(J), I) ) THEN
               P1 = P1 - 1
               IW(P1) = IX(J)
             ELSE
               P0 = P0 + 1
               IW(P0) = IX(J)
             END IF
          END DO
         END IF  ! even or odd i

         ODD = .NOT. ODD
       END DO  ! next i

*=======================================================================
*        the sign bit
*=======================================================================
       P1OLD = P1
       P0OLD = P0
       P1 = N+1
       P0 = 0

*          if sign bit is set, send to the zero end
       DO J = 1, P0OLD, +1
         IF ( BTEST(IW(J), ILIM-1) ) THEN
           P0 = P0 + 1
           IX(P0) = IW(J)
         ELSE
           P1 = P1 - 1
           IX(P1) = IW(J)
         END IF
       END DO
       DO J = N, P1OLD, -1
         IF ( BTEST(IW(J), ILIM-1) ) THEN
           P0 = P0 + 1
           IX(P0) = IW(J)
         ELSE
           P1 = P1 - 1
           IX(P1) = IW(J)
         END IF
       END DO

*=======================================================================
*       Reverse the order of the greater value partition
*=======================================================================
       P1OLD = P1
       DO J = N, (P1OLD+N)/2+1, -1
         SWAP = IX(J)
         IX(J) = IX(P1)
         IX(P1) = SWAP
         P1 = P1 + 1
       END DO
       RETURN
      END ! of RSORT


***********************************************************************
*         test program
***********************************************************************
      PROGRAM t_sort
       IMPLICIT NONE
       INTEGER I, N
       PARAMETER (N = 11)
       INTEGER IX(N), IW(N)
       LOGICAL OK

       DATA IX / 2, 24, 45, 0, 66, 75, 170, -802, -90, 1066, 666 /

       PRINT *, 'before: ', IX
       CALL RSORT (IX, IW, N)
       PRINT *, 'after: ', IX

*              compare
       OK = .TRUE.
       DO I = 1, N-1
         IF (IX(I) > IX(I+1)) OK = .FALSE.
       END DO
       IF (OK) THEN
         PRINT *, 't_sort: successful test'
       ELSE
         PRINT *, 't_sort: failure!'
       END IF
      END ! of test program
