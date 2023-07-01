program writefloats
  implicit none

  real, dimension(10) :: a, sqrta
  integer :: i
  integer, parameter :: unit = 40

  a = (/ (i, i=1,10) /)
  sqrta = sqrt(a)

  open(unit, file="xydata.txt", status="new", action="write")
  call writexy(unit, a, sqrta)
  close(unit)

contains

  subroutine writexy(u, x, y)
    real, dimension(:), intent(in) :: x, y
    integer, intent(in) :: u

    integer :: i

    write(u, "(2F10.4)") (x(i), y(i), i=lbound(x,1), ubound(x,1))
  end subroutine writexy

end program writefloats
