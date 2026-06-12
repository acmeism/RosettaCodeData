!
! Ormiston pairs
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program Ormiston2
implicit none
integer, parameter ::limit = 10000000     ! 10 millions
integer, allocatable,dimension(:) :: primes
integer :: highPrimes
integer :: ii
integer :: count, count1Mio, NumbersInLine

count=0
NumbersInLine = 0
count1Mio = 0
call SievePrimes (limit)
do ii=0, highPrimes-1
  if (isAnagram (primes(ii), primes (ii+1))) then
    count = count + 1
    if (count .le. 30) then
      write (*, '("(",i5,",",i5,")",x)', advance='no')  primes(ii),primes(ii+1)
      NumbersInLine = NumbersInLine+1
      if (NumbersInLine .eq. 3) then
        write (*,*)
        NumbersInLine = 0
      endif
    endif
  endif
  if (primes(ii) .ge. 1000000 .and. count1Mio .eq. 0) then
    count1Mio = count
  endif
enddo

write (*,'(/,"Up to ", i0, " there are ", i0, " Ormiston pairs.")')   1000000, count1Mio
write (*,'(/,"Up to ", i0, " there are ", i0, " Ormiston pairs.")')   limit, count


contains

! ===========================================================================
! Decide whether n1 and 2 contain identical digits, i.e. they are an anagram.
! ===========================================================================
function isAnagram (n1, n2) result (YN)
integer, intent(in) :: n1, n2
logical :: YN
integer :: ii
integer, save :: oldN2 =-2
integer, dimension(0:9), save :: digitsCountN1, digitsCountN2

! The only self-coded optimisation is here: see if previous ne (the larger of n1 and n2)
! values has been memoised and hence this time here it is the smaller of the 2 values,.
! If so, use the results for that number.
if (n1 .ne. oldn2) then                     ! 1st time here? previous upper value not yet saved?
  call getDigits (n1, digitsCountN1)        ! so we need to evaluate digit counts for N1
else
  digitsCountN1 = digitsCountN2             ! Otherwise just copy saved previous result.
endif
call getDigits (n2, digitsCountN2)          ! Evan for n2 in all cases.
oldn2 = n2                                  ! Save for next time

! Check whether both counter arrays are identical. The first difference is enough
! fort the decision against an anagram.
do ii=0, 9
  if (digitsCountN1(ii) .ne. digitsCountN2(ii)) then
    YN = .false.                            ! not identical: early return "not an anagram"
    return
  end if
end do
YN = .true.                                 ! Here if both counter arrays identical.
end function isAnagram


! ==========================================================
! Count the digits of n, sort counters in array  digitsCount
! ==========================================================
subroutine getDigits (n, digitsCount)
integer, intent(in) :: n
integer, dimension(0:9), intent(out) :: digitsCount
integer :: nn, lastdig
digitsCount = 0
nn = n
do while (nn .ne. 0)
  lastdig = mod(nn, 10)
  digitsCount(lastdig) = digitsCount(lastdig) + 1
  nn = nn/10
end do

end subroutine getDigits

! ==================================================================
! The usual, omnipresent sieve to produce an array of prime numbers
! ==================================================================
subroutine SievePrimes(lmt)
  implicit none
  integer :: lmt
  integer(kind=1), dimension(:), allocatable :: sieve
  integer :: p,i,delta

  allocate (sieve (lmt/2) )
  sieve=0
  ! estimate count of prime
  i = int (real(lmt,8)/(log (real(lmt, 8))-1.1_8))
  allocate (primes(0:i-1))
  highPrimes = i-1          ! highes usable index
  p = 1
  do
    delta = 2*p+1
    !  ((2*p+1)^2 ) -1)/ 2 = ((4*p*p+4*p+1) -1)/2 = 2*p*(p+1)
    i = 2*p*(p+1)
    if (i.gt. size(sieve))  exit

    do while (i <= size(sieve))
      sieve(i) = 1
      i = i+delta
    end do
    p=p+1
    do while (sieve(p) .ne. 0)
      p=p+1
    end do
  end do

  primes(0) = 2
  i = 1
  do p = 1,  size (sieve)
    if  (sieve(p) .eq.  0)   then
      primes(i) = 2*p+1
      i = i+1
    endif
  end do
  highPrimes = i-1    ! instead of (in Fortran) non-existant re-allocate with reduced length
end subroutine SievePrimes


end program Ormiston2
