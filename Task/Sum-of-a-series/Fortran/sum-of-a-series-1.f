real, dimension(1000) :: a = (/ (1.0/(i*i), i=1, 1000) /)
real :: result

result = sum(a);
