program zero
double precision :: i, j
double complex :: z1, z2
i = 0.0D0
j = 0.0D0
z1 = (0.0D0,0.0D0)
z2 = (0.0D0,0.0D0)
write(*,*) 'When integers are used, we have 0^0 = ', 0**0
write(*,*) 'When double precision numbers are used, we have 0.0^0.0 = ', i**j
write(*,*) 'When complex numbers are used, we have (0.0+0.0i)^(0.0+0.0i) = ', z1**z2
end program
