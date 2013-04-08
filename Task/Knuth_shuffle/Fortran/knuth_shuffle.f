program Knuth_Shuffle
  implicit none

  integer, parameter :: reps = 1000000
  integer :: i, n
  integer, dimension(10) :: a, bins = 0, initial = (/ (n, n=1,10) /)

  do i = 1, reps
    a = initial
 	call Shuffle(a)
    where (a == initial) bins = bins + 1  ! skew tester
  end do
  write(*, "(10(i8))") bins
! prints  100382  100007   99783  100231  100507   99921   99941  100270  100290  100442

contains

subroutine Shuffle(a)
  integer, intent(inout) :: a(:)
  integer :: i, randpos, temp
  real :: r

  do i = size(a), 2, -1
    call random_number(r)
    randpos = int(r * i) + 1
    temp = a(randpos)
    a(randpos) = a(i)
    a(i) = temp
  end do

end subroutine Shuffle

end program Knuth_Shuffle
