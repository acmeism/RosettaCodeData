program Example
  implicit none

  real :: ra(5,10)
  integer :: ia(5,10)
  integer :: i, j

  call random_number(ra)
  ia = int(ra * 20.0) + 1

outer: do i = 1, size(ia, 1)
         do j = 1, size(ia, 2)
           write(*, "(i3)", advance="no") ia(i,j)
           if (ia(i,j) == 20) exit outer
         end do
         write(*,*)
       end do outer

end program Example
