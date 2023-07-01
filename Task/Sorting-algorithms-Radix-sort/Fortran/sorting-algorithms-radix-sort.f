      SUBROUTINE VARRADIX(A , Siz)

!
!	No Copyright is exerted due to considerable prior art in the Public Domain.
!       This Fortran version by Peter Kelly ~ peter.kelly@acm.org
!
!	Permission is hereby granted, free of charge, to any person obtaining
!	a copy of this software and associated documentation files (the
!	"Software"), to deal in the Software without restriction, including
!	without limitation the rights to use, copy, modify, merge, publish,
!	distribute, sublicense, and/or sell copies of the Software, and to
!	permit persons to whom the Software is furnished to do so, subject to
!	the following conditions:
!	The above copyright notice and this permission notice shall be
!	included in all copies or substantial portions of the Software.
!	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
!	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
!	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
!	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
!	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
!	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
!	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
!
!
!     LSD sort with a configurable RADIX, Using a RADIX of 256 performs well, hence I have defaulted it in. It is snarly fast.
!     It could be optimized by merging the two routines but this way gives greater clarity as to what's going on.
      IMPLICIT NONE
!
! PARAMETER definitions
!
      INTEGER , PARAMETER  ::  BASE = 256 ! whatever base you need, just change this
!
! Dummy arguments
!
      INTEGER  ::  Siz
      INTEGER , DIMENSION(Siz)  ::  A
!
! Local variables
!
      INTEGER , ALLOCATABLE , DIMENSION(:)  ::  b
      INTEGER , ALLOCATABLE , DIMENSION(:)  ::  c
      INTEGER  ::  exps
      INTEGER  ::  maxs
!
      ALLOCATE(b(Siz))
      ALLOCATE(c(BASE))

      exps = 1
      maxs = MAXVAL(A)
      DO WHILE ( (maxs/exps)>0 )
         CALL XXCOUNTING_SORT(A , Siz , exps , BASE , b , c)
         exps = exps*BASE
      END DO
      deallocate(C)
      deallocate(B)
      RETURN
      CONTAINS
!
!//b is the base you want
!//exp is the value used for the division
      SUBROUTINE XXCOUNTING_SORT(A , Siz , Exps , Base , B , C)
      IMPLICIT NONE
! I used zero based arrays as it made the calcs infinitely easier :)
!
! Dummy arguments
!
      INTEGER  ::  Base
      INTEGER  ::  Exps
      INTEGER  ::  Siz    ! Size
      INTEGER , DIMENSION(0:)  ::  A
      INTEGER , DIMENSION(0:)  ::  B
      INTEGER , DIMENSION(0:)  ::  C
      INTENT (IN) Base , Exps , Siz
      INTENT (INOUT) A , B , C
!
! Local variables
!
      INTEGER  ::  i
      INTEGER  ::  k
!
      C = 0                             ! Init the arrays
      B = 0
!
      DO i = 0 , Siz - 1 , 1
         k = MOD((A(i)/Exps) , Base)    ! Fill Histo
         C(k) = C(k) + 1
      END DO
!
      DO i = 1 , Base - 1 , 1
         C(i) = C(i) + C(i - 1)         ! Build cumulative Histo
      END DO
!
      DO i = Siz - 1 , 0 , -1
         k = MOD(A(i)/Exps , Base)      ! Load the Buffer Array in order
         B(C(k) - 1) = A(i)
         C(k) = C(k) - 1
      END DO
!
      DO i = 0 , Siz - 1 , 1              ! Copy across
         A(i) = B(i)
      END DO
      RETURN
      END SUBROUTINE XXCOUNTING_SORT
    END SUBROUTINE Varradix
!***************************************************************************
!                            End of LSD sort with any Radix
!***************************************************************************
      MODULE LEASTSIG
      IMPLICIT NONE
!
!	No Copyright is exerted due to considerable prior art in the Public Domain.
!       This Fortran version by Peter Kelly ~ peter.kelly@acm.org
!
!	Permission is hereby granted, free of charge, to any person obtaining
!	a copy of this software and associated documentation files (the
!	"Software"), to deal in the Software without restriction, including
!	without limitation the rights to use, copy, modify, merge, publish,
!	distribute, sublicense, and/or sell copies of the Software, and to
!	permit persons to whom the Software is furnished to do so, subject to
!	the following conditions:
!	The above copyright notice and this permission notice shall be
!	included in all copies or substantial portions of the Software.
!	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
!	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
!	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
!	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
!	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
!	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
!	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
!
!     Implementation of a classic Radix Sort LSD style :)
!     Works well, Integers only but it goes faster than a comparison sort
      CONTAINS

! Main Radix Sort sort function
      SUBROUTINE LSDRADIXSORT(A , N)
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  N
      INTEGER , target, DIMENSION(0:N - 1)  ::  A           ! All arrays based off zero, one day I'll fix it
      INTENT (IN) N
      INTENT (INOUT) A
!
! Local variables
!
      INTEGER , DIMENSION(0:9)  ::  counts
      INTEGER  ::  digitplace
      INTEGER  ::  i
      INTEGER  ::  j
      INTEGER  ::  largestnum
      INTEGER, DIMENSION(0:N - 1)  ::  results
!
      digitplace = 1                                        ! Count of the keys
      largestnum = MAXVAL(A)

      DO WHILE ( (largestnum/digitplace)>0 )
         counts = 0                                         ! Init the count array
        DO i = 0 , N - 1 , 1
            J = (A(i)/digitplace)
            J = MODULO(j , 10)
            counts(j) = counts(j) + 1
        END DO

!  Change count(i) so that count(i) now contains actual position of this digit in result()
!  Working similar to the counting sort algorithm
         DO i = 1 , 9 , 1
            counts(i) = counts(i) + counts(i - 1)       ! Build up the prefix sum
         END DO
!
         DO i = N - 1 , 0 , -1                          ! Move from left to right
            j = (A(i)/digitplace)
            j = MODULO(j, 10)
            results(counts(j) - 1) = A(i)               ! Need to subtract one as we are zero based but prefix sum is 1 based
            counts(j) = counts(j) - 1
         END DO
!
         DO i = 0 , N - 1 , 1                           ! Copy the semi-sorted data into the input
           A(i) = results(i)
         END DO
!
         digitplace = digitplace*10
      END DO                                             ! While loop
      RETURN
      END SUBROUTINE LSDRADIXSORT
      END MODULE LEASTSIG
!***************************************************************************
!                            End of Classic LSD sort with Radix 10
!***************************************************************************
!Superfast FORTRAN LSD sort
! Dataset is input array, Scratch is working array
!
      SUBROUTINE FASTLSDRAD(Dataset , Scratch , Dsize)
!
!	No Copyright is exerted due to considerable prior art in the Public Domain.
!       This Fortran version by Peter Kelly ~ peter.kelly@acm.org
!
!	Permission is hereby granted, free of charge, to any person obtaining
!	a copy of this software and associated documentation files (the
!	"Software"), to deal in the Software without restriction, including
!	without limitation the rights to use, copy, modify, merge, publish,
!	distribute, sublicense, and/or sell copies of the Software, and to
!	permit persons to whom the Software is furnished to do so, subject to
!	the following conditions:
!	The above copyright notice and this permission notice shall be
!	included in all copies or substantial portions of the Software.
!	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
!	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
!	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
!	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
!	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
!	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
!	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
!
!     This LSD sort is optimized to a base 16,Radix 256 sort which is about as fast as LSD gets. As well as a fast
!     algorithm, it has great cache coherency so performs exceptionally on large data sets,
!     I have optimized out all the divide and modulus functions and replaced them with bit shifts for speed.
!     A further speed optimization is obtained by using pointers to the DATA and TEMP arrays and swapping them each pass of
!     the LSB calculation. In FORTRAN this is a bit clunky but much faster than copying data back and forth between arrays.
!
!     All arrays are zero based as this makes the indexing calculations straightforward without the need for
!     subsequent adds and subtracts to track the correct index
!         .
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  Dsize
      INTEGER , TARGET , DIMENSION(0:Dsize - 1)  ::  Scratch    ! Declared as TARGET as we will manipulate with pointers
      INTEGER , TARGET , DIMENSION(0:Dsize - 1)  ::  Dataset
      INTENT (IN) Dsize
      INTENT (INOUT) Scratch , Dataset
!
! Local variables
!
      INTEGER , POINTER , DIMENSION(:)  ::  a                   ! The pointer to the data
      INTEGER , POINTER , DIMENSION(:)  ::  b                   ! The pointer to the buffer
      INTEGER  ::  i
      INTEGER  ::  j
      INTEGER  ::  m
      INTEGER , DIMENSION(0:255,0:3)  ::  stats_table
      INTEGER  ::  n
      LOGICAL  ::  swap
      INTEGER  ::  u

!
      stats_table = 0                                           !   index matrix
      swap = .TRUE.                                             !   For swapping pointers
!
      a => Dataset
      b => Scratch
!
      DO i = 0 , Dsize - 1 , 1                                  ! generate histograms
         u = a(i)
         DO j = 0 , 3 , 1
            n = IAND(u , z'FF')
            u = SHIFTR(u , 8)
            stats_table(n,j) = stats_table(n,j) + 1
         END DO
      END DO
!
      DO i = 0 , 3 , 1                                          ! convert to indices
         m = 0
         DO j = 0 , 255 , 1
            n = stats_table(j , i)
            stats_table(j , i) = m
            m = m + n
         END DO
      END DO
!
      DO j = 0 , 3 , 1                                          ! Radix Sort, sort by LSB
         DO i = 0 , Dsize - 1 , 1
            u = a(i)
            m = IAND(SHIFTR(u,SHIFTL(j,3)) , z'FF')             ! Eliminate the MOD 16 and div with shifts
            b(stats_table(m,j)) = u                             ! Push the data into the buffer
            stats_table(m,j) = stats_table(m,j) + 1
         END DO
!
!        Instead of copying back from the temp values swap the array pointers
!
         IF( swap )THEN
            a => Scratch                                        ! A now points to the b buffer
            b => Dataset                                        ! B now is the data set
         ELSE
            a => Dataset
            b => Scratch
         END IF
         swap = .NOT.swap                                       ! Set to swap back and forth every pass
      END DO
 !
      RETURN
      END SUBROUTINE FASTLSDRAD
!***************************************************************************
!                            End of Superfast LSD sort
!***************************************************************************
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
*
        ILIM = Bit_size(i)    !Get the fixed number of bits
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
