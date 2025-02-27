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
!
! Performs a MSD radi sort using bits.
! It sorts only using the bit size of the largest and smallest numbers
! So, on small numbers < 128, it's faster than a Quicksort for very large numbers > 20 bits
! It's slower.
! Author: Peter Kelly
! No claim is made on the code and no warranty implied.
module msd_bit_sort_module
    implicit none
    private
    public :: msd_bit_sort

contains
    ! Transform signed integer to make it comparable
    PURE FUNCTION transform_for_sort(x) RESULT(transformed)
        INTEGER, INTENT(IN) :: x
        INTEGER :: transformed

        ! XOR with sign bit to make negative numbers sortable
        ! This inverts the bit representation for negative numbers
        transformed = IEOR(x, ISHFT(-1, BIT_SIZE(x)-1))
    END FUNCTION transform_for_sort


    RECURSIVE SUBROUTINE msd_bit_sort_internal(arr, left, right, bit)
        INTEGER, INTENT(INOUT) :: arr(:)
        INTEGER, INTENT(IN) :: left, right, bit
        INTEGER :: i, j, temp
        INTEGER :: transformed_i, transformed_j

        ! Base case
        IF (left >= right .OR. bit < 0) RETURN

        i = left
        j = right

        DO WHILE (i <= j)
            ! Find elements to swap
            DO WHILE (i <= j)
                transformed_i = transform_for_sort(arr(i))
                transformed_j = transform_for_sort(arr(j))

                ! Partition based on transformed values
                IF (BTEST(transformed_i, bit) .AND. .NOT. BTEST(transformed_j, bit)) THEN
                    ! Swap needed
                    temp = arr(i)
                    arr(i) = arr(j)
                    arr(j) = temp
                    EXIT
                END IF

                ! Move pointers
                IF (.NOT. BTEST(transformed_i, bit)) i = i + 1
                IF (BTEST(transformed_j, bit)) j = j - 1
            END DO

            ! Adjust pointers
            IF (i < j) THEN
                i = i + 1
                j = j - 1
            END IF
        END DO

        ! Recursively sort sub-arrays
        IF (left < j) THEN
            CALL msd_bit_sort_internal(arr, left, j, bit-1)
        END IF
        IF (i < right) THEN
            CALL msd_bit_sort_internal(arr, i, right, bit-1)
        END IF
    END SUBROUTINE msd_bit_sort_internal

    SUBROUTINE msd_bit_sort(arr)
        INTEGER, INTENT(INOUT) :: arr(:)
        INTEGER :: max_bit, n, mini, maxi

        n = SIZE(arr)
        IF (n < 2) RETURN

        ! Find most significant bit
        mini = MINVAL(arr)
        maxi = MAXVAL(arr)
        max_bit = MAX(BIT_SIZE(arr(1)) - LEADZ(IEOR(mini, maxi)) - 1, 0)

        ! Perform the recursive bit sort
        CALL msd_bit_sort_internal(arr, 1, n, max_bit)
    END SUBROUTINE msd_bit_sort
    end module msd_bit_sort_module
!
    program bit_sort_test_harness
    use msd_bit_sort_module
    implicit none

    INTEGER, PARAMETER :: ARRAY_SIZE = 2**23
    INTEGER :: test_array(ARRAY_SIZE)
    real :: holder(ARRAY_SIZE)
    INTEGER :: xx,yy,rate
    call random_number(holder)
    holder = holder -0.33333
    test_array = int(holder*1000000.0)
    ! Initialize with some test values

    PRINT *, "Original Array:"
    PRINT *, test_array(1:10)
    call system_clock(count=xx,count_rate=rate)
    CALL msd_bit_sort(test_array)
    call system_clock(count=yy)
    print*,'sort time = ',(real(yy-xx)/rate)
    PRINT *, "Sorted Array:"
    PRINT *, test_array(1:5),test_array(array_size-5:)

end program bit_sort_test_harness
