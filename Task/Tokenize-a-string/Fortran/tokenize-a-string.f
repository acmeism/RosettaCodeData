PROGRAM Example

  CHARACTER(23) :: str = "Hello,How,Are,You,Today"
  CHARACTER(5) :: word(5)
  INTEGER :: pos1 = 1, pos2, n = 0, i

  DO
    pos2 = INDEX(str(pos1:), ",")
    IF (pos2 == 0) THEN
       n = n + 1
       word(n) = str(pos1:)
       EXIT
    END IF
    n = n + 1
    word(n) = str(pos1:pos1+pos2-2)
    pos1 = pos2+pos1
 END DO

 DO i = 1, n
   WRITE(*,"(2A)", ADVANCE="NO") TRIM(word(i)), "."
 END DO

END PROGRAM Example
