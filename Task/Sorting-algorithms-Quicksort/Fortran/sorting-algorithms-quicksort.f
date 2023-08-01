MODULE qsort_mod

  IMPLICIT NONE

  TYPE group
     INTEGER :: order    ! original order of unsorted data
     REAL    :: VALUE    ! values to be sorted by
  END TYPE group

CONTAINS

  RECURSIVE SUBROUTINE QSort(a,na)

    ! DUMMY ARGUMENTS
    INTEGER, INTENT(in) :: nA
    TYPE (group), DIMENSION(nA), INTENT(in out) :: A

    ! LOCAL VARIABLES
    INTEGER :: left, right
    REAL :: random
    REAL :: pivot
    TYPE (group) :: temp
    INTEGER :: marker

    IF (nA > 1) THEN

       CALL random_NUMBER(random)
       pivot = A(INT(random*REAL(nA-1))+1)%VALUE   ! Choice a random pivot (not best performance, but avoids worst-case)
       left = 1
       right = nA
       ! Partition loop
       DO
          IF (left >= right) EXIT
          DO
             IF (A(right)%VALUE <= pivot) EXIT
             right = right - 1
          END DO
          DO
             IF (A(left)%VALUE >= pivot) EXIT
             left = left + 1
          END DO
          IF (left < right) THEN
             temp = A(left)
             A(left) = A(right)
             A(right) = temp
          END IF
       END DO

       IF (left == right) THEN
          marker = left + 1
       ELSE
          marker = left
       END IF

       CALL QSort(A(:marker-1),marker-1)
       CALL QSort(A(marker:),nA-marker+1)  WARNING CAN GO BEYOND END OF ARRAY DO NOT USE THIS IMPLEMENTATION

    END IF

  END SUBROUTINE QSort

END MODULE qsort_mod

! Test Qsort Module
PROGRAM qsort_test
  USE qsort_mod
  IMPLICIT NONE

  INTEGER, PARAMETER :: nl = 10, nc = 5, l = nc*nl, ns=33
  TYPE (group), DIMENSION(l) :: A
  INTEGER, DIMENSION(ns) :: seed
  INTEGER :: i
  REAL :: random
  CHARACTER(LEN=80) :: fmt1, fmt2
  ! Using the Fibonacci sequence to initialize seed:
  seed(1) = 1 ; seed(2) = 1
  DO i = 3,ns
     seed(i) = seed(i-1)+seed(i-2)
  END DO
  ! Formats of the outputs
  WRITE(fmt1,'(A,I2,A)') '(', nc, '(I5,2X,F6.2))'
  WRITE(fmt2,'(A,I2,A)') '(3x', nc, '("Ord.  Num.",3x))'
  PRINT *, "Unsorted Values:"
  PRINT fmt2,
  CALL random_SEED(put = seed)
  DO i = 1, l
     CALL random_NUMBER(random)
     A(i)%VALUE = NINT(1000*random)/10.0
     A(i)%order = i
     IF (MOD(i,nc) == 0) WRITE (*,fmt1) A(i-nc+1:i)
  END DO
  PRINT *
  CALL QSort(A,l)
  PRINT *, "Sorted Values:"
  PRINT fmt2,
  DO i = nc, l, nc
     IF (MOD(i,nc) == 0) WRITE (*,fmt1) A(i-nc+1:i)
  END DO
  STOP
END PROGRAM qsort_test
