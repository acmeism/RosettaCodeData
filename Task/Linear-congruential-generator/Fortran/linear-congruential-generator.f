module lcgs
  implicit none

  integer, parameter :: i64 = selected_int_kind(18)
  integer, parameter :: a1 = 1103515245, a2 = 214013
  integer, parameter :: c1 = 12345, c2 = 2531011
  integer, parameter :: div = 65536
  integer(i64), parameter :: m = 2147483648_i64  ! need to go to 64 bits because
                                                 ! of the use of signed integers
contains

function bsdrand(seed)
  integer :: bsdrand
  integer, optional, intent(in) :: seed
  integer(i64) :: x = 0

  if(present(seed)) x = seed
  x = mod(a1 * x + c1, m)
  bsdrand = x
end function

function msrand(seed)
  integer :: msrand
  integer, optional, intent(in) :: seed
  integer(i64) :: x = 0

  if(present(seed)) x = seed
  x = mod(a2 * x + c2, m)
  msrand = x / div
end function
end module

program lcgtest
  use lcgs
  implicit none
  integer :: i

  write(*, "(a)") "      BSD            MS"
  do i = 1, 10
    write(*, "(2i12)") bsdrand(), msrand()
  end do
end program
