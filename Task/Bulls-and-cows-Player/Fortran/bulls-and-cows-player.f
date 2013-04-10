module Player
  implicit none

contains

subroutine Init(candidates)
  integer, intent(in out) :: candidates(:)
  integer :: a, b, c, d, n

           n = 0
thousands: do a = 1, 9
hundreds:    do b = 1, 9
tens:          do c = 1, 9
units:           do d = 1, 9
                   if (b == a) cycle hundreds
                   if (c == b .or. c == a) cycle tens
                   if (d == c .or. d == b .or. d == a) cycle units
                   n = n + 1
                   candidates(n) = a*1000 + b*100 + c*10 + d
                 end do units
               end do tens
             end do hundreds
           end do thousands

end subroutine init

subroutine Evaluate(bulls, cows, guess, candidates)
  integer, intent(in) :: bulls, cows, guess
  integer, intent(in out) :: candidates(:)
  integer :: b, c, s, i, j
  character(4) :: n1, n2

  write(n1, "(i4)") guess
  do i = 1, size(candidates)
    if (candidates(i) == 0) cycle
    b = 0
    c = 0
    write(n2, "(i4)") candidates(i)
    do j = 1, 4
      s = index(n1, n2(j:j))
      if(s /= 0) then
        if(s == j) then
          b = b + 1
        else
          c = c + 1
        end if
      end if
    end do
    if(.not.(b == bulls .and. c == cows)) candidates(i) = 0
  end do
end subroutine Evaluate

function Nextguess(candidates)
  integer :: Nextguess
  integer, intent(in out) :: candidates(:)
  integer :: i

  nextguess = 0
  do i = 1, size(candidates)
    if(candidates(i) /= 0) then
      nextguess = candidates(i)
      candidates(i) = 0
      return
     end if
  end do
end function
end module Player

program Bulls_Cows
  use Player
  implicit none

  integer :: bulls, cows, initial, guess
  integer :: candidates(3024) = 0
  real :: rnum

! Fill candidates array with all possible number combinations
  call Init(candidates)

! Random initial guess
  call random_seed
  call random_number(rnum)
  initial = 3024 * rnum + 1
  guess = candidates(initial)
  candidates(initial) = 0

  do
    write(*, "(a, i4)") "My guess is ", guess
    write(*, "(a)", advance = "no") "Please score number of Bulls and Cows: "
    read*, bulls, cows
    write(*,*)
    if (bulls == 4) then
      write(*, "(a)") "Solved!"
      exit
    end if

! We haven't found the solution yet so evaluate the remaining candidates
! and eliminate those that do not match the previous score given
    call Evaluate(bulls, cows, guess, candidates)

! Get the next guess from the candidates that are left
    guess = Nextguess(candidates)
    if(guess == 0) then
! If we get here then no solution is achievable from the scores given or the program is bugged
      write(*, "(a)") "Sorry! I can't find a solution. Possible mistake in the scoring"
      exit
    end if
  end do
end program
