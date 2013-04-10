program test_loc

  implicit none
  integer :: i
  real :: r

  i = loc (r)
  write (*, '(i0)') i

end program test_loc
