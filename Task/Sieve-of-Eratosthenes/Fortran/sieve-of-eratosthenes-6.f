program sieve_wheel_2

  implicit none
  integer, parameter :: i_max = 100
  integer, parameter :: i_limit = (i_max - 3) / 2
  integer :: i
  byte, dimension (0:i_limit) :: composites

  composites = 0
  do i = 0, (int (sqrt (real (i_max))) - 3) / 2
    if (composites(i) == 0) composites ((i + i) * (i + 3) + 3 : i_limit : i + i + 3) = 1.
  end do
  write (*, '(i0, 1x)', advance = 'no') 2
  do i = 0, i_limit
    if (composites (i) == 0) write (*, '(i0, 1x)', advance = 'no') (i + i + 3)
  end do
  write (*, *)

end program sieve_wheel_2
