!
! Count the coins
! ---------------
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
!
! No non-standard Fortran extensions have been used. It should compile and run using
! any fairly recent Fortran compiler.
! U.B., December 2025
!==============================================================================


program coins

! Note that gfortran (but only gfortran) can handle integer (kind=16) and do
! the calculation for larger examples within reasonable time. Only up to longI = 8
! is portable.

integer, parameter :: longI=8

! Print results for the two examples of the task description
print *, countWays (     100, [1,5,10,25], 4)
print *, countWays (  100000, [1,5,10,25,50,100],6)

contains

! ========================================================================
! Count the number of ways an amount of money (in Cent) can be paid using
! coins from a given set of con values.
! This is a standard example for Dynamic Programming, to be found in every
! text book on Algorithmics .
! ========================================================================

function countWays (amount, coinset, nCoins) result (cnt)
integer, intent(in) :: amount             ! in Cents
integer, intent(in) :: coinset(*)         ! the different coins that can be used
integer, intent(in) :: nCoins             ! number of different available coins
integer (kind=longI) cnt                  ! Result

integer (kind=longI)    DP (0:amount+1)   ! Array for Dynamic Programming (sub problems)
integer :: ii, jj                         ! Two Loop indices

! Initialize DP
DP(0) = 1                                 ! 1 way to give zero dollars.
do ii=1, amount+1                         ! prepare the rest
  DP(ii) =  0
end do

! Dynamic programming: accumulate sub-problems from smallest up to 'amount'
do ii=1, nCoins
  do jj=coinset(ii), amount
    DP(jj) = DP(jj) + DP(jj-coinset(ii))
  enddo
enddo

cnt = DP(amount)

end function countWays

end program coins
