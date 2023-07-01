program Bias_Unbias
  implicit none

  integer, parameter :: samples = 1000000
  integer :: i, j
  integer :: c1, c2, rand

  do i = 3, 6
    c1 = 0
    c2 = 0
    do j = 1, samples
      rand = bias(i)
      if (rand == 1) c1 = c1 + 1
      rand = unbias(i)
      if (rand == 1) c2 = c2 + 1
    end do
    write(*, "(i2,a,f8.3,a,f8.3,a)") i, ":", real(c1) * 100.0 / real(samples), &
                                     "%", real(c2) * 100.0 / real(samples), "%"
  end do

contains

function bias(n)
  integer :: bias
  integer, intent(in) :: n
  real :: r

  call random_number(r)
  if (r > 1 / real(n)) then
    bias = 0
  else
    bias = 1
  end if
end function

function unbias(n)
  integer :: unbias
  integer, intent(in) :: n
  integer :: a, b

  do
    a = bias(n)
    b = bias(n)
    if (a /= b) exit
  end do
  unbias = a
end function

end program
