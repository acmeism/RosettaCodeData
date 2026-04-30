!
! Ormiston triplets
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
! NOT VSI Fortran on OpenVMS because of excessive memory requirement
! U.B., April 2026
!
program Ormiston3
implicit none
integer, parameter :: int64=8
integer(kind=int64), parameter ::limit = 10000000000_int64     ! 1 billion, 10 billions might overwhelm the computer
integer(kind=int64), dimension(:), allocatable :: primes
integer(kind=int64) :: highPrimes
integer(kind=int64) :: ii
integer :: count, count1B, NumbersInLine

count=0
NumbersInLine = 0
count1B = 0
call SievePrimes (limit)
write (*,'("Smallest members of first 25 Ormiston triples:")')
do ii=0, highPrimes-2
  if (isAnagram (primes(ii), primes (ii+1), primes(ii+2))) then
    count = count + 1
    if (count .le. 25) then
      write (*, '(i8,x)', advance='no')  primes(ii)   ! Smallest member of the 1st 25 triplets
      NumbersInLine = NumbersInLine+1
      if (NumbersInLine .eq. 5) then
        write (*,*)
        NumbersInLine = 0
      endif
    endif
  endif
  ! Store count of 1 Million for later output
  if (primes(ii) .ge. 1000000000_int64 .and. count1B .eq. 0) then
    count1B = count
  endif
enddo
! Print the 1-million counter only if the limit is higher than 1 million.
if (limit .gt. 1000000000_int64) write (*,'(/,"Up to ", i0, " there are ", i0, " Ormiston triples.")')   1000000000, count1B
write (*,'(/,"Up to ", i0, " there are ", i0, " Ormiston triples.")')   limit, count


contains

! ===========================================================================
! Decide whether n1 and 2 contain identical digits, i.e. they are an anagram.
! ===========================================================================
function isAnagram (n1, n2, n3) result (YN)
integer(kind=int64), intent(in) :: n1, n2, n3
logical :: YN
integer :: ii
integer(kind=int64), save :: oldN3 =-2
integer, dimension(0:9), save :: digitsCountN1, digitsCountN2, digitsCountN3

if (n2 .ne. oldn3) then                     ! 1st time here? previous upper value not yet saved?
  call getDigits (n1, digitsCountN1)        ! so we need to evaluate digit counts for N1
  call getDigits (n2, digitsCountN2)        ! so we need to evaluate digit counts for N1
else
  digitsCountN1 = digitsCountN2             ! Otherwise just copy saved previous result.
  digitsCountN2 = digitsCountN3             ! Otherwise just copy saved previous result.
endif
call getDigits (n3, digitsCountN3)          ! Eval for n3 in all cases.
oldn3 = n3                                  ! Save for next time

! Check whether both counter arrays are identical. The first difference is enough
! fort the decision against an anagram.
do ii=0, 9
  if (digitsCountN1(ii) .ne. digitsCountN2(ii)) then
    YN = .false.                            ! digits of n1 and n2 not identical: early return "not an anagram"
    return
  endif
  if (digitsCountN1(ii) .ne. digitsCountN3(ii)) then
    YN = .false.                            ! digits of n1 and n3 not identical: early return "not an anagram"
    return
  end if
end do
YN = .true.                                 ! Here if both counter arrays identical.
end function isAnagram


! ==========================================================
! Count the digits of n, sort counters in array  digitsCount
! ==========================================================
subroutine getDigits (n, digitsCount)
integer(kind=int64), intent(in) :: n
integer, dimension(0:9), intent(out) :: digitsCount
integer(kind=int64) :: nn
integer :: lastdig
digitsCount = 0
nn = n
do while (nn .ne. 0_int64)
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
  integer(kind=int64) :: lmt
  integer(kind=1), dimension(:), allocatable :: sieve
  integer(kind=int64) :: p,i,delta

  allocate (sieve (lmt/2) )
  if ( .not. allocated (sieve)) then    ! ERROR if allocation fails
    print *, 'Sieve not allocated.'
    STOP
  endif
  sieve=0
  ! estimate count of primes
  i = int (real(lmt,8)/(log (real(lmt, 8))-1.1_8))

  allocate (primes(0:i-1_int64))
  if ( .not. allocated (primes)) then
    print *, 'Primes not allocated.'
    STOP
  endif
  highPrimes = i-1_int64          ! highes usable index
  p = 1
  do
    delta = 2_int64*p+1_int64
    !  ((2*p+1)^2 ) -1)/ 2 = ((4*p*p+4*p+1) -1)/2 = 2*p*(p+1)
    i = 2_int64*p*(p+1_int64)
    if (i.gt. lmt/2) then !   size(sieve))  then
      exit
    endif

    do while (i <= lmt/2) ! size(sieve))
      sieve(i) = 1
      i = i+delta
    end do
    p=p+1_int64
    do while (sieve(p) .ne. 0)
      p=p+1_int64
    end do
  end do

  primes(0) = 2
  i = 1
  do p = 1,  lmt/2 !  size (sieve)
    if  (sieve(p) .eq.  0)   then
      primes(i) = 2_int64*p+1_int64
      i = i+1_int64
    endif
  end do
  highPrimes = i-1_int64    ! instead of (in Fortran) non-existant re-allocate with reduced length
end subroutine SievePrimes


end program Ormiston3
