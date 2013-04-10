program Movavg
  implicit none

  integer :: i
	
  write (*, "(a)") "SIMPLE MOVING AVERAGE: PERIOD = 3"

  do i = 1, 5
    write (*, "(a, i2, a, f8.6)") "Next number:", i, "   sma = ", sma(real(i))
  end do
  do i = 5, 1, -1
    write (*, "(a, i2, a, f8.6)") "Next number:", i, "   sma = ", sma(real(i))
  end do

contains

function sma(n)
  real :: sma
  real, intent(in) :: n
  real, save :: a(3) = 0
  integer, save :: count = 0

  if (count < 3) then
    count = count + 1
    a(count) = n
  else
    a = eoshift(a, 1, n)
  end if

  sma = sum(a(1:count)) / real(count)
end function

end program Movavg
