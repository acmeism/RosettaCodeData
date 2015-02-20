program Concat_Arrays
implicit none

  integer, dimension(3) :: a = [ 1, 2, 3 ]
  integer, dimension(3) :: b = [ 4, 5, 6 ]
  integer, dimension(:), allocatable :: c

  allocate(c(size(a)+size(b)))
  c(1:size(a)) = a
  c(size(a)+1:size(a)+size(b)) = b

  write(*,*) c

end program Concat_Arrays
