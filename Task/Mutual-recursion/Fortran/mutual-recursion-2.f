program testmutrec
  use MutualRec
  implicit none

  integer :: i
  integer, dimension(20) :: a = (/ (i, i=0,19) /), b = (/ (i, i=0,19) /)
  integer, dimension(20) :: ra, rb

  forall(i=1:20)
     ra(i) = m(a(i))
     rb(i) = f(b(i))
  end forall

  write(*,'(20I3)') rb
  write(*,'(20I3)') ra

end program testmutrec
