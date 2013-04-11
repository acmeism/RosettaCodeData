program MaxSubSeq
  implicit none

  integer, parameter :: an = 11
  integer, dimension(an) :: a = (/ -1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1 /)

  integer, dimension(an,an) :: mix
  integer :: i, j
  integer, dimension(2) :: m

  forall(i=1:an,j=1:an) mix(i,j) = sum(a(i:j))
  m = maxloc(mix)
  ! a(m(1):m(2)) is the wanted subsequence
  print *, a(m(1):m(2))

end program MaxSubSeq
