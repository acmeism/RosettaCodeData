program Sierpinski_triangle
  implicit none

  call Triangle(4)

contains

subroutine Triangle(n)
  implicit none
  integer, parameter :: i64 = selected_int_kind(18)
  integer, intent(in) :: n
  integer :: i, k
  integer(i64) :: c

  do i = 0, n*4-1
    c = 1
    write(*, "(a)", advance="no") repeat(" ", 2 * (n*4 - 1 - i))
    do k = 0, i
      if(mod(c, 2) == 0) then
        write(*, "(a)", advance="no") "    "
      else
        write(*, "(a)", advance="no") "  * "
      end if
      c = c * (i - k) / (k + 1)
    end do
    write(*,*)
  end do
end subroutine Triangle
end program Sierpinski_triangle
