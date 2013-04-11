PROGRAM SELECTION

  IMPLICIT NONE

  INTEGER :: intArray(10) = (/ 4, 9, 3, -2, 0, 7, -5, 1, 6, 8 /)

  WRITE(*,"(A,10I5)") "Unsorted array:", intArray
  CALL Selection_sort(intArray)
  WRITE(*,"(A,10I5)") "Sorted array  :", intArray

CONTAINS

  SUBROUTINE Selection_sort(a)
    INTEGER, INTENT(IN OUT) :: a(:)
    INTEGER :: i, minIndex, temp

    DO i = 1, SIZE(a)-1
       minIndex = MINLOC(a(i:), 1) + i - 1
       IF (a(i) > a(minIndex)) THEN
          temp = a(i)
          a(i) = a(minIndex)
          a(minIndex) = temp
       END IF
    END DO
  END SUBROUTINE Selection_sort

END PROGRAM SELECTION
