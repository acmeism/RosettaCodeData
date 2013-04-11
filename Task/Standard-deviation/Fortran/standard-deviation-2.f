program stats
  implicit none

  integer, parameter :: N = 8
  integer            :: data(N)
  real(8)            :: mean
  real(8)            :: std_dev1, std_dev2

  ! Set the data
  data = [2,4,4,4,5,5,7,9] ! Strictly this is a Fortran 2003 construct

  ! Use intrinsic function 'sum' to calculate the mean
  mean = sum(data)/N

  ! Method1:
  ! Calculate the standard deviation directly from the definition
  std_dev1 = sqrt(sum((data - mean)**2)/N)

  ! Method 2:
  ! Use the alternative version that is less susceptible to rounding error
  std_dev2 = sqrt(sum(data**2)/N - mean**2)

  write(*,'(a,8i2)') 'Data = ',data
  write(*,'(a,f3.1)') 'Mean = ',mean
  write(*,'(a,f3.1)') 'Standard deviation (method 1) = ',std_dev1
  write(*,'(a,f3.1)') 'Standard deviation (method 2) = ',std_dev2

end program stats
