DO i = 1, 5
  DO j = 1, i
    WRITE(*, "(A)", ADVANCE="NO") "*"
  END DO
  WRITE(*,*)
END DO
