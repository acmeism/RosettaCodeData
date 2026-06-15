!
! Prime numbers which contain 123
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., June 2026

program Primes123

implicit none

integer, parameter :: tInt=4                                      ! Small problem, small integers
integer(kind=tInt), parameter ::limit = 1000000_tInt
integer (kind=tInt), parameter ::smallerlimit = 100000_tInt
integer(kind=tInt), dimension(:), allocatable :: primes
integer(kind=tInt) :: ii
integer(kind=tInt) :: highPrimes

integer :: countsmall, countlarge, NumbersInLine

call SievePrimes (limit)

numbersInLine = 0
countsmall = 0
countlarge = 0
do ii=1,  highPrimes
  if (has123(primes(ii))) then
    if (primes(ii) .lt. smallerlimit) then
      ! Count + print
      countsmall = countsmall + 1
      countlarge = countlarge + 1
      write (*, '(i7)', advance='no' )   primes(ii)
      numbersInLine = numbersInLine + 1
      if (numbersInLine .eq. 10) then
        numbersInLine = 0
        write (*,*)
      endif
    else
      ! Only count them
      countlarge = countlarge + 1
    endif
  endif
end do
if (numbersInLine .gt. 0) write (*,*)
write (*,'("found ", i3, " primes with 123 less than ", i7, " and ", /, "      ", i3, " primes with 123 less than ", i7 )') countsmall,smallerlimit, countlarge, limit

contains

function has123 (n) result (YN)
integer, intent(in) :: n
logical :: YN
integer :: nn

YN = .false.
nn = n
do while (nn .ge. 123)                    ! Only then last three digits can be 123
  if (mod (nn,1000) .eq. 123) then        ! Are last 3 digits 123?
    YN = .true.                           ! OK, do early return
    return
  end if
  nn = nn / 10                            ! forget last digit and try next smaller nn.
end do

end function has123

! ==================================================================
! The usual, omnipresent sieve to produce an array of prime numbers
! ==================================================================
subroutine SievePrimes(lmt)

  integer(kind=tInt) :: lmt
  integer(kind=1), dimension(:), allocatable :: sieve
  integer(kind=tInt) :: p,i,delta

  allocate (sieve (lmt/2) )
  if ( .not. allocated (sieve)) then    ! ERROR if allocation fails
    print *, 'Sieve not allocated.'
    STOP
  endif
  sieve=0
  ! estimate count of primes
  i = int (real(lmt,8)/(log (real(lmt, 8))-1.1_8))

  allocate (primes(0:i-1_tInt))
  if ( .not. allocated (primes)) then
    print *, 'Primes not allocated.'
    STOP
  endif
  highPrimes = i-1_tInt          ! highes usable index
  p = 1
  do
    delta = 2_tInt*p+1_tInt
    !  ((2*p+1)^2 ) -1)/ 2 = ((4*p*p+4*p+1) -1)/2 = 2*p*(p+1)
    i = 2_tInt*p*(p+1_tInt)
    if (i.gt. lmt/2) then !   size(sieve))  then
      exit
    endif

    do while (i <= lmt/2)
      sieve(i) = 1
      i = i+delta
    end do
    p=p+1_tInt
    do while (sieve(p) .ne. 0)
      p=p+1_tInt
    end do
  end do

  primes(0) = 2
  i = 1
  do p = 1,  lmt/2
    if  (sieve(p) .eq.  0)   then
      primes(i) = 2_tInt*p+1_tInt
      i = i+1_tInt
    endif
  end do
  highPrimes = i-1_tInt    ! instead of (in Fortran) non-existant re-allocate with reduced length
end subroutine SievePrimes

end program Primes123
