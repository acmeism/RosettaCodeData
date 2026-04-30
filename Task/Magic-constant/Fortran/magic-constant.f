! Magic constant
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program magicConstant
implicit none
integer,parameter :: DP=8, k_int=4

real(kind=DP), parameter :: realten=10._DP

integer(kind=k_int) :: order, ii
! Starting at order 3, show the first 20 magic constants.

write (*, '("Count  Order  Magic")')
order = 3
do ii=1,20
  write (*,'(i5, 2x, i5,2x,i0)') ii, order, magicNumber (order)
  order = order + 1
end do

! Show the 1000th magic constant. (Order 1003)
! 1st magic constant is for order 3, i.e. order = count+2
write (*,*)
order = 1002
ii = 1000
write (*,'(i5, 2x, i5,2x,i0,/)') ii, order, magicNumber (order)
!
! Find and show the order of the smallest N x N magic square whose constant is greater than 10^1 through 10^10.
! Stretch
! Find and show the order of the smallest N x N magic square whose constant is greater than 10^11 through 10^20.
!
write (*, '(" Limit  Order")')
do i=1,20
  order =  unmagic (realten**i)                  ! Using REAL for all 10^i to avoid 132 bit integers
  write (*,'("10**", i2, 2x, i0)')    i, order
end do

contains

! =============================================
! Return the magic number of a sqare of order n
! =============================================
pure function magicNumber (n) result (retval)
implicit none
integer(kind=k_int), intent(in) :: n
integer(kind=k_int) :: retval
integer (kind=k_int) :: nn
nn = n
retval = (nn**3+nn) / 2

end function magicNumber

! =====================================================================================
! return the order of the smallest magic square with a magic number >=  a given "magic"
! =====================================================================================
function unMagic (magic) result (order)
implicit none
real (kind=DP), intent(in) :: magic

real (kind=DP) :: guess
integer(kind=k_int) :: order

integer(kind=k_int) :: lo,hi,mid, mnc, mnf

! Following formula calculates an approximate value of the order we're looking for.
! This is because the  term n^3 in the formula for the Magic Number is dominant,
! so the correct (real) value of the magic square's order is most likely between
! Floor and Ceiling of this first guess, so the integer result is CEILING (guess)
!
! It turned out this approximation and using ceiling(this guess) as function
! value is correct for all test values up to 10^20.

guess = (2._DP*magic)**(1._8/3._8)

! This check is only here because above reasoning is (maybe) plausible, but it is
! not a conclusive proof. This function allows us to check whether any results are incorrect.
if (checkGuess (magic, guess)) then
  order = ceiling (guess, k_int)
else
  order=-1  ! signal fault
  print *, 'Problem: Guess for inverse magic fails for ', magic
endif

end function unMagic

! ========================================================================================================
! Check if the value of "guess" fulfills the condition
!     magicNumber (floor(guess) <= magic < magicNumber(ceiling(guess)
! Special care has be taken to avoid integer overflows. Note that argument 'magic' can be as large as 10^20,
! and 'guess' is (2*guess)^(1/3)), which is .lt. 10^7.  So guess , floor(guess) and ceiling(guess)
! can be represented by a 32-bin integer word, but 'magic' would cause an integer overflow.
! So we replicate the calculation of the integer function magicNumber(n) here, but we
! use double precision results instead of integers.
! ========================================================================================================
!
function checkGuess (magic, guess)   result (guessIsOK)
real (kind=DP), intent(in) :: magic, guess
logical :: guessIsOK

real (kind=DP) :: FloorGuess, CeilingGuess
real (kind=dp) :: CeilingMagic,FloorMagic

FloorGuess   = real (floor (guess, k_int) , DP)
FloorMagic   = (Floorguess**3 + Floorguess) /2.0_DP

CeilingGuess = real (ceiling (guess, k_int) , DP)
CeilingMagic = (CeilingGuess**3 + Ceilingguess) /2.0_DP

guessIsOK = FloorMagic .le. magic .and. magic .lt. CeilingMagic

end function checkGuess

end program magicConstant
