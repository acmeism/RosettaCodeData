PROGRAM ZIGZAG

  IMPLICIT NONE
    INTEGER, PARAMETER :: size = 5
    INTEGER :: zzarray(size,size), x(size*size), y(size*size), i, j

    ! index arrays
    x = (/ ((j, i = 1, size), j = 1, size) /)
    y = (/ ((i, i = 1, size), j = 1, size) /)

    ! Sort indices
    DO i = 2, size*size
       j = i - 1
       DO WHILE (j>=1 .AND. (x(j)+y(j)) > (x(i)+y(i)))
          j = j - 1
       END DO
       x(j+1:i) = cshift(x(j+1:i),-1)
       y(j+1:i) = cshift(y(j+1:i),-1)
    END DO

    ! Create zig zag array
    DO i = 1, size*size
       IF (MOD(x(i)+y(i), 2) == 0) THEN
          zzarray(x(i),y(i)) = i - 1
       ELSE
          zzarray(y(i),x(i)) = i - 1
       END IF
    END DO

    ! Print zig zag array
    DO j = 1, size
       DO i = 1, size
          WRITE(*, "(I5)", ADVANCE="NO") zzarray(i,j)
       END DO
       WRITE(*,*)
    END DO

 END PROGRAM ZIGZAG
