program Magic_Square
  implicit none

  integer, parameter :: order = 15
  integer :: i, j

  write(*, "(a, i0)") "Magic Square Order: ", order
  write(*, "(a)")     "----------------------"
  do i = 1, order
    do j = 1, order
      write(*, "(i4)", advance = "no") f1(order, i, j)
    end do
    write(*,*)
  end do
  write(*, "(a, i0)") "Magic number = ", f2(order)

contains

integer function f1(n, x, y)
  integer, intent(in) :: n, x, y

  f1 = n * mod(x + y - 1 + n/2, n) + mod(x + 2*y - 2, n) + 1
end function

integer function f2(n)
  integer, intent(in) :: n

  f2 = n * (1 + n * n) / 2
end function
end program
