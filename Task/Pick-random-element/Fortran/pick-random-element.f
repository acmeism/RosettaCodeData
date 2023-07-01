program pick_random
  implicit none

  integer :: i
  integer :: a(10) = (/ (i, i = 1, 10) /)
  real :: r

  call random_seed
  call random_number(r)
  write(*,*) a(int(r*size(a)) + 1)
end program
