MODULE Qsort_Module

IMPLICIT NONE

CONTAINS

RECURSIVE SUBROUTINE Qsort(a)

  INTEGER, INTENT(IN OUT) :: a(:)
  INTEGER :: split

  IF(size(a) > 1) THEN
     CALL Partition(a, split)
     CALL Qsort(a(:split-1))
     CALL Qsort(a(split:))
  END IF

END SUBROUTINE Qsort

SUBROUTINE Partition(a, marker)

  INTEGER, INTENT(IN OUT) :: a(:)
  INTEGER, INTENT(OUT) :: marker
  INTEGER :: left, right, pivot, temp

  pivot = (a(1) + a(size(a))) / 2  ! Average of first and last elements to prevent quadratic
  left = 0                         ! behavior with sorted or reverse sorted data
  right = size(a) + 1

  DO WHILE (left < right)
     right = right - 1
     DO WHILE (a(right) > pivot)
        right = right-1
     END DO
     left = left + 1
     DO WHILE (a(left) < pivot)
        left = left + 1
     END DO
     IF (left < right) THEN
        temp = a(left)
        a(left) = a(right)
        a(right) = temp
     END IF
  END DO

  IF (left == right) THEN
     marker = left + 1
  ELSE
     marker = left
  END IF

END SUBROUTINE Partition

END MODULE Qsort_Module

PROGRAM Quicksort

  USE Qsort_Module

  IMPLICIT NONE
  INTEGER, PARAMETER :: n = 100
  INTEGER :: array(n)
  INTEGER :: i
  REAL :: x
    CALL RANDOM_SEED
  DO i = 1, n
     CALL RANDOM_NUMBER(x)
     array(i) = INT(x * 10000)
  END DO

  WRITE (*, "(A)") "array is :-"
  WRITE (*, "(10I5)") array
  CALL Qsort(array)
  WRITE (*,*)
  WRITE (*, "(A)") "sorted array is :-"
  WRITE (*,"(10I5)") array

END PROGRAM Quicksort
