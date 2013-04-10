OPEN (UNIT=5, FILE="output.txt", STATUS="NEW")   ! Current directory
CLOSE (UNIT=5)
OPEN (UNIT=5, FILE="/output.txt", STATUS="NEW")  ! Root directory
CLOSE (UNIT=5)
