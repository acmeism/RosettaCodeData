PROGRAM Example

  CHARACTER(80) :: str = "This is a string"
  CHARACTER :: temp
  INTEGER :: i, length

  WRITE (*,*) str
  length = LEN_TRIM(str) ! Ignores trailing blanks. Use LEN(str) to reverse those as well
  DO i = 1, length/2
     temp = str(i:i)
     str(i:i) = str(length+1-i:length+1-i)
     str(length+1-i:length+1-i) = temp
  END DO
  WRITE(*,*) str

END PROGRAM Example
