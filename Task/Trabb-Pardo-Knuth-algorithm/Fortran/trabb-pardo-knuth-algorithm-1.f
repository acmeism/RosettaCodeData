program tpk
  implicit none

  real, parameter :: overflow = 400.0
  real :: a(11), res
  integer :: i

  write(*,*) "Input eleven numbers:"
  read(*,*) a

  a = a(11:1:-1)
  do i = 1, 11
    res = f(a(i))
    write(*, "(a, f0.3, a)", advance = "no") "f(", a(i), ") = "
    if(res > overflow) then
      write(*, "(a)") "overflow!"
    else
       write(*, "(f0.3)") res
    end if
  end do

contains

real function f(x)
  real, intent(in) :: x

  f = sqrt(abs(x)) + 5.0*x**3

end function
end program
