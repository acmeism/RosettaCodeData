real, dimension(1000) :: a = (/ (i, i=1, 1000) /)
real, pointer, dimension(:) :: p => a(2:1)       ! pointer to zero-length array
real :: result, zresult

result = sum(a*a)    ! Multiply array by itself to get squares

result = sum(a**2)   ! Use exponentiation operator to get squares

zresult = sum(p*p)   ! P is zero-length; P*P is valid zero-length array expression; SUM(P*P) == 0.0 as expected
