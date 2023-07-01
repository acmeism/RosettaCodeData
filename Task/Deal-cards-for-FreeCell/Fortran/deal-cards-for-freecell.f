module Freecell
  use lcgs
  implicit none

  character(4)  :: suit = "CDHS"
  character(13) :: rank = "A23456789TJQK"
  character(2) :: deck(0:51)

contains

subroutine Createdeck()
  integer :: i, j, n

  n = 0
  do i = 1, 13
    do j = 1, 4
      deck(n) = rank(i:i) // suit(j:j)
      n = n + 1
    end do
  end do

end subroutine

subroutine Freecelldeal(game)
  integer, intent(in) :: game
  integer(i64) :: rnum
  integer :: i, n
  character(2) :: tmp

  call Createdeck()
  rnum = msrand(game)

  do i = 51, 1, -1
    n = mod(rnum, i+1)
    tmp = deck(n)
    deck(n) = deck(i)
    deck(i) = tmp
    rnum = msrand()
  end do

  write(*, "(a, i0)") "Game #", game
  write(*, "(8(a, tr1))") deck(51:0:-1)
  write(*,*)

end subroutine
end module Freecell

program Freecell_test
  use Freecell
  implicit none

  call Freecelldeal(1)
  call Freecelldeal(617)

end program
