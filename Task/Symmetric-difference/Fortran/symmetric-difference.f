program Symmetric_difference
implicit none

  character(6) :: a(4) = (/ "John  ", "Bob   ", "Mary  ", "Serena" /)
  character(6) :: b(4) = (/ "Jim   ", "Mary  ", "John  ", "Bob   " /)
  integer :: i, j

outer1: do i = 1, size(a)
          do j = 1, i-1
            if(a(i) == a(j)) cycle outer1   ! Do not check duplicate items
          end do
          if(.not. any(b == a(i))) write(*,*) a(i)
        end do outer1

outer2: do i = 1, size(b)
          do j = 1, i-1
            if(b(i) == b(j)) cycle outer2   ! Do not check duplicate items
          end do
          if(.not. any(a == b(i))) write(*,*) b(i)
        end do outer2

end program
