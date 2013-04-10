PROGRAM DOORS

  INTEGER, PARAMETER :: n = 100    ! Number of doors
  INTEGER :: i, j
  LOGICAL :: door(n) = .TRUE.      ! Initially closed

  DO i = 1, n
    DO j = i, n, i
      door(j) = .NOT. door(j)
    END DO
  END DO

  DO i = 1, n
    WRITE(*,"(A,I3,A)", ADVANCE="NO") "Door ", i, " is "
    IF (door(i)) THEN
      WRITE(*,"(A)") "closed"
    ELSE
      WRITE(*,"(A)") "open"
    END IF
  END DO

END PROGRAM DOORS
