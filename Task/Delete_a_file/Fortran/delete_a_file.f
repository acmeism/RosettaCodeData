OPEN (UNIT=5, FILE="input.txt", STATUS="OLD")   ! Current directory
CLOSE (UNIT=5, STATUS="DELETE")
OPEN (UNIT=5, FILE="/input.txt", STATUS="OLD")  ! Root directory
CLOSE (UNIT=5, STATUS="DELETE")
