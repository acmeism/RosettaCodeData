program compare
integer a, b
c        fortran 77 I/O statements, for simplicity
read(*,*) a, b

if (a .lt. b) write(*, *) a, ' is less than ', b
if (a .eq. b) write(*, *) a, ' is equal to ', b
if (a .gt. b) write(*, *) a, ' is greater than ', b
end
