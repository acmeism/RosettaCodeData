! Dice game probabilities
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., February 2026
!=========================================================================================
program DiceGame

implicit none

integer, parameter :: longInteger=8, double=8

write (*,'(1x,F19.14)')  beating_probability(4_longInteger, 9_longInteger, 6_longInteger, 6_longInteger)
write (*,'(1x,F19.14)')  beating_probability(10_longInteger, 5_longInteger, 7_longInteger, 6_longInteger)

contains

! =================================================================================
! count all possible Results of both players
! then see how often player 1 has sum larger than player 2's sum
! Probability that Player 1 wins is this number divided by nuimber of all possible
! outcomes of both  players combined.
! =================================================================================

function beating_probability (nSides1, nDice1, nSides2, nDice2) result (tot)

integer (kind=longInteger), intent(in) :: nSides1, nDice1, nSides2, nDice2
real (kind=double) :: tot

real (kind=double) :: p12
integer (kind=longInteger) ::  i, j

! Counters for all possible sums of all dice of Players 1 and 2 (index is sum)
! sum can go from nDice up to nDice * nSides (incl)
integer (kind=longInteger), dimension (nSides1 * nDice1) :: C1  ! C1(1...nDice1-1) unused, always 0
integer (kind=longInteger), dimension (nSides2 * nDice2) :: C2  ! C2(1...nDice2-1) unused, always 0

! Initialise counters
C1=0_longInteger
C2=0_longInteger

! count sums of all combinations separately for Player 1 and Player 2
call throw_die (nSides1, nDice1, 0_longInteger, C1)
call throw_die (nSides2, nDice2, 0_longInteger, C2)

p12 = nSides1 ** nDice1 * nSides2 ** nDice2   ! Number of of all possible combinations
tot = 0._double

! for all of player 1's potential dice sums, find out how often they win
! against player 2
do i=nDice1, nSides1 * nDice1                                    ! For each of Player 1's sums
  ! C1(i) is count of player 1's sum being i,
  ! see how many combinations of player 2 are smaller than this combi:
  ! Max sum2 is C1(i)-1 or Size(C2), whatever is smaller
  do j=nDice2, min(i-1, nSides2*nDice2)
    ! C2(j) is count for player 2's sum being j
    ! partial probability of combination (i,j) is (C1(i) * C2(j) / all possible results), add up to total prob.
    tot =tot + real(C1(i)*C2(j), double) / p12
  enddo
enddo
end function beating_probability

! ====================================================================
! Throw all dices: construct all possible combinations of the dice.
! Variable "sum" is the accumulated result of of all nDice dice.
! Variable "counts(sum)" counts how many times a particular sum occurs
! ====================================================================
recursive subroutine throw_die (nSides, nDice, sum, counts)

integer (kind=longInteger), intent(in) :: nSides, nDice, sum
integer(kind=longInteger), dimension(*) , intent(inout) :: counts
integer (kind=longInteger) :: i

if (nDice .eq. 0) then
  ! All dice have been thrown. "sum" is the result of all dice added up.
  ! in this particular constellation. Increment the sum's counter
  counts(sum) = counts(sum) + 1_longInteger
else
  ! construct all combinations of a dice: take the value of the faces of this
  ! dice plus the combination of the (nDice-1) remaining dice
  do i=1, nSides
    call throw_die (nSides, nDice-1, sum+i, counts)
  enddo
endif
end subroutine throw_die

end program DiceGame
