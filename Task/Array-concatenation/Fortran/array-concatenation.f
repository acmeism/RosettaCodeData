program Concat_Arrays
implicit none

  ! Note: in Fortran 90 you must use the old array delimiters (/ , /)
  integer, dimension(3) :: a = [1, 2, 3] ! (/1, 2, 3/)
  integer, dimension(3) :: b = [4, 5, 6] ! (/4, 5, 6/)
  integer, dimension(:), allocatable :: c, d

  allocate(c(size(a)+size(b)))
  c(1 : size(a)) = a
  c(size(a)+1 : size(a)+size(b)) = b
  write(*,*) c

  ! alternative
  d = [a, b] ! (/a, b/)
  write(*,*) d

  deallocate(c)
  deallocate(d)

end program Concat_Arrays
