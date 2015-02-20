module subgenerator
  implicit none

  integer, parameter :: modulus = 1000000000
  integer :: s(0:54), r(0:54)

contains

subroutine initgen(seed)
  integer :: seed
  integer :: n, rnum

  s(0) = seed
  s(1) = 1

  do n = 2, 54
    s(n) = mod(s(n-2) - s(n-1), modulus)
    if (s(n) < 0) s(n) = s(n) + modulus
  end do

  do n = 0, 54
    r(n) = s(mod(34*(n+1), 55))
  end do

  do n = 1, 165
    rnum = subrand()
  end do

end subroutine initgen

integer function subrand()
  integer, save :: p1 = 0
  integer, save :: p2 = 31

  r(p1) = mod(r(p1) - r(p2), modulus)
  if (r(p1) < 0) r(p1) = r(p1) + modulus
  subrand = r(p1)
  p1 = mod(p1 + 1, 55)
  p2 = mod(p2 + 1, 55)

end function subrand
end module subgenerator

program subgen_test
  use subgenerator
  implicit none

  integer :: seed = 292929
  integer :: i

  call initgen(seed)
  do i = 1, 10
    write(*,*) subrand()
  end do

end program
