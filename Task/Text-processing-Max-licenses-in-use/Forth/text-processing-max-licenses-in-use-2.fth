 PROGRAM MAX_LICENSES
   IMPLICIT NONE

   INTEGER :: out=0, maxout=0, maxcount=0, err
   CHARACTER(50) :: line
   CHARACTER(19) :: maxtime(100)

   OPEN (UNIT=5, FILE="Licenses.txt", STATUS="OLD", IOSTAT=err)
   IF (err > 0) THEN
     WRITE(*,*) "Error opening file Licenses.txt"
     STOP
   END IF

   DO
     READ(5, "(A)", IOSTAT=err) line
     IF (err == -1) EXIT          ! EOF detected
     IF (line(9:9) == "O") THEN
       out = out + 1
     ELSE IF (line(9:9) == "I") THEN
       out = out - 1
     END IF
     IF (out > maxout ) THEN
       maxout = maxout + 1
       maxcount = 1
       maxtime(maxcount) = line(15:33)
     ELSE IF (out == maxout) THEN
       maxcount = maxcount + 1
       maxtime(maxcount) = line(15:33)
     END IF
   END DO

   CLOSE(5)

   WRITE(*,"(A,I4,A)") "Maximum simultaneous license use is", maxout, " at the following times:"
   WRITE(*,"(A)") maxtime(1:maxcount)

 END PROGRAM MAX_LICENSES
