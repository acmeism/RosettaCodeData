program Sierpinski_carpet
  implicit none

  call carpet(4)

contains

function In_carpet(a, b)
  logical :: in_carpet
  integer, intent(in) :: a, b
  integer :: x, y

  x = a ; y = b
  do
    if(x == 0 .or. y == 0) then
      In_carpet = .true.
      return
    else if(mod(x, 3) == 1 .and. mod(y, 3) == 1) then
      In_carpet = .false.
      return
    end if
    x = x / 3
    y = y / 3
  end do
end function

subroutine Carpet(n)
  integer, intent(in) :: n
  integer :: i, j

  do i = 0, 3**n - 1
    do j = 0, 3**n - 1
      if(In_carpet(i, j)) then
        write(*, "(a)", advance="no") "#"
      else
        write(*, "(a)", advance="no") " "
      end if
    end do
    write(*,*)
  end do
end subroutine Carpet
end program Sierpinski_carpet
