program sieve_wheel_2

  implicit none
  integer, parameter :: i_max = 100
  integer :: i
  logical, dimension (i_max) :: is_prime

  is_prime = .true.
  is_prime (1) = .false.
  is_prime (4 : i_max : 2) = .false.
  do i = 3, int (sqrt (real (i_max))), 2
    if (is_prime (i)) is_prime (i * i : i_max : 2 * i) = .false.
  end do
  do i = 1, i_max
    if (is_prime (i)) write (*, '(i0, 1x)', advance = 'no') i
  end do
  write (*, *)

end program sieve_wheel_2
