program test_loc
  implicit none

  integer :: i
  real    :: r

  i = loc(r)
  print *, i
end program
