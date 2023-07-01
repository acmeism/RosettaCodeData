SUBROUTINE Bubble_Sort(a)
  REAL, INTENT(in out), DIMENSION(:) :: a
  REAL :: temp
  INTEGER :: i, j
  LOGICAL :: swapped

  DO j = SIZE(a)-1, 1, -1
    swapped = .FALSE.
    DO i = 1, j
      IF (a(i) > a(i+1)) THEN
        temp = a(i)
        a(i) = a(i+1)
        a(i+1) = temp
        swapped = .TRUE.
      END IF
    END DO
    IF (.NOT. swapped) EXIT
  END DO
END SUBROUTINE Bubble_Sort
