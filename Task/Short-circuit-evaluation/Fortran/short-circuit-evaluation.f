program Short_Circuit_Eval
  implicit none

  logical :: x, y
  logical, dimension(2) :: l = (/ .false., .true. /)
  integer :: i, j

  do i = 1, 2
    do j = 1, 2
      write(*, "(a,l1,a,l1,a)") "Calculating x = a(", l(i), ") and b(", l(j), ")"
      ! a AND b
      x = a(l(i))
      if(x) then
        x = b(l(j))
        write(*, "(a,l1)") "x = ", x
      else
        write(*, "(a,l1)") "x = ", x
      end if

      write(*,*)
      write(*, "(a,l1,a,l1,a)") "Calculating y = a(", l(i), ") or b(", l(j), ")"
      ! a OR b
      y = a(l(i))
      if(y) then
        write(*, "(a,l1)") "y = ", y
      else
        y = b(l(j))
        write(*, "(a,l1)") "y = ", y
      end if
      write(*,*)
    end do
  end do

contains

function a(value)
  logical :: a
  logical, intent(in) :: value

  a = value
  write(*, "(a,l1,a)") "Called function a(", value, ")"
end function

function b(value)
  logical :: b
  logical, intent(in) :: value

  b = value
  write(*, "(a,l1,a)") "Called function b(", value, ")"
end function
end program
