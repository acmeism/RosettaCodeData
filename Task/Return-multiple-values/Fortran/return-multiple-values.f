module multiple_values
implicit none
type res
  integer :: p, m
end type

contains

function addsub(x,y) result(r)
  integer :: x, y
  type(res) :: r
  r%p = x+y
  r%m = x-y
end function
end module

program main
  use multiple_values
  print *, addsub(33, 22)
end program
