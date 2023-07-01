program arithif
integer a, b

c        fortran 77 I/O statements, for simplicity
read(*,*) a, b

if ( a - b ) 10, 20, 30
10 write(*,*) a, ' is less than ', b
   goto 40

20 write(*,*) a, ' is equal to ', b
   goto 40

30 write(*,*) a, ' is greater than ', b
40 continue

end
