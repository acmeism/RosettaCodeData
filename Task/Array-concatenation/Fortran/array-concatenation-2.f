program Concat_Arrays
implicit none

  integer, dimension(3) :: a = [ 1, 2, 3 ]
  integer, dimension(3) :: b = [ 4, 5, 6 ]
  integer, dimension(:), allocatable :: c

  c = [a, b]

  write(*,*) c

end program Concat_Arrays
