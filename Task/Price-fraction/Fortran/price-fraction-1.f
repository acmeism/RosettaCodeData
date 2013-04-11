program price_fraction

  implicit none
  integer, parameter :: i_max = 10
  integer :: i
  real, dimension (20), parameter :: in =                           &
    & (/0.00, 0.06, 0.11, 0.16, 0.21, 0.26, 0.31, 0.36, 0.41, 0.46, &
    &   0.51, 0.56, 0.61, 0.66, 0.71, 0.76, 0.81, 0.86, 0.91, 0.96/)
  real, dimension (20), parameter :: out =                          &
    & (/0.10, 0.18, 0.26, 0.32, 0.38, 0.44, 0.50, 0.54, 0.58, 0.62, &
    &   0.66, 0.70, 0.74, 0.78, 0.82, 0.86, 0.90, 0.94, 0.98, 1.00/)
  real :: r

  do i = 1, i_max
    call random_number (r)
    write (*, '(f8.6, 1x, f4.2)') r, out (maxloc (in, r >= in))
  end do

end program price_fraction
