module rand_mod
  implicit none

contains

function rand5()
  integer :: rand5
  real :: r

  call random_number(r)
  rand5 = 5*r + 1
end function

function rand7()
  integer :: rand7

  do
    rand7 = 5*rand5() + rand5() - 6
    if (rand7 < 21) then
      rand7 = rand7 / 3 + 1
      return
    end if
  end do
end function
end module

program Randtest
  use rand_mod
  implicit none

  integer, parameter :: samples = 1000000

  call distcheck(rand7, samples, 0.005)
  write(*,*)
  call distcheck(rand7, samples, 0.001)

end program
