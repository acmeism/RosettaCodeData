! Logistic curve fitting in epidemiology
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
! BUT NOT VSI Fortran x86-64 V8.7-001 because it does not like the parameter
! with assumed size (*)
! U.B., February 2026
!=========================================================================================
program LogisticCurve
implicit none
integer, parameter :: DP = 8
real (kind=DP), parameter :: actual (*) = [                             &
    27, 27, 27, 44, 44, 59, 59, 59, 59, 59, 59, 59, 59, 60, 60,         &
    61, 61, 66, 83, 219, 239, 392, 534, 631, 897, 1350, 2023, 2820,     &
    4587, 6067, 7823, 9826, 11946, 14554, 17372, 20615, 24522, 28273,   &
    31491, 34933, 37552, 40540, 43105, 45177, 60328, 64543, 67103,      &
    69265, 71332, 73327, 75191, 75723, 76719, 77804, 78812, 79339,      &
    80132, 80995, 82101, 83365, 85203, 87024, 89068, 90664, 93077,      &
    95316, 98172, 102133, 105824, 109695, 114232, 118610, 125497,       &
    133852, 143227, 151367, 167418, 180096, 194836, 213150, 242364,     &
    271106, 305117, 338133, 377918, 416845, 468049, 527767, 591704,     &
    656866, 715353, 777796, 851308, 928436, 1000249, 1082054, 1174652   ]

real (kind=DP), parameter :: K=7.8D9, n0=27_DP

real (kind=DP) :: r, R0

r = solve_default (f)
R0 = exp (12_DP*r)

write (*,'("r = ", f9.6, ", R0 = ", f9.6)' )  r, R0

contains


function f (r) result (sq)
integer, parameter :: DP = 8

real (kind=DP), intent(in) :: r
real (kind=DP) :: sq

real (kind=DP) :: eri, guess, diff
integer :: i

sq = 0_DP

do i=0, size(actual)-1
  eri = exp (r*i)
  guess = (n0*eri) / (1+n0*(eri-1)/K)
  diff = guess - actual(i+1)
  sq = sq + diff*diff
enddo
end function f

function solve (fn, guess_ro, epsilon) result (retval)

integer, parameter :: DP = 8

interface
   function fn (r) result(sq)
  integer, parameter :: DP = 8

  real (kind=DP), intent(in) :: r
  real (kind=DP) :: sq
  end function fn
end interface

real (kind=DP), intent(in) :: guess_ro, epsilon
real (kind=DP) :: retval, guess

real (kind=DP) :: delta, f0, factor, nf

guess = guess_ro
if (guess .ne. 0) then
  delta = guess
else
  delta = 1.
end if
f0 = fn(guess)
factor = 2._DP

do while (delta .gt. epsilon .and. guess .ne. guess-delta)
  nf = fn (guess-delta)
  if (nf .lt. f0) then
    f0 = nf
    guess = guess - delta
  else
    nf = fn(guess+delta)
    if (nf .lt. f0) then
      f0 = nf
      guess = guess + delta
    else
      factor = 0.5
    endif
  endif

  delta = factor*delta
end do
retval = guess
end function solve

function solve_default (fn)   result (retval)
integer, parameter :: DP = 8
interface
   function fn (r) result(sq)
  integer, parameter :: DP = 8
  real (kind=DP), intent(in) :: r
  real (kind=DP) :: sq
  end function fn
end interface
real (kind=DP) :: retval

retval = solve (fn, 0.5_DP, 0.0_DP)

end function solve_default


end program  LogisticCurve
