PROGRAM CREATION
OPEN (UNIT=5, FILE="output.txt", STATUS="NEW")   ! Current directory
CLOSE (UNIT=5)
OPEN (UNIT=5, FILE="/output.txt", STATUS="NEW")  ! Root directory
CLOSE (UNIT=5)

!Directories (Use System from GNU Fortran Compiler)
! -- Added by Anant Dixit, November 2014
call system("mkdir docs/")
call system("mkdir ~/docs/")

END PROGRAM
