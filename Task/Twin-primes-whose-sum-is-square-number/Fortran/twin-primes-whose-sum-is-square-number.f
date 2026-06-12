! Twin Primes
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! Note that VMS requires switch $Fortran/ccdefault=LIST
! otherwise 1st character of each output line is interpreted as
! Carriage Control character.
!
!
module  SieveEratosthenes
  implicit none

  logical (kind=1), allocatable :: isPrime(:)
  integer :: primeCount

  contains

    function initPrimes (limit)  result (count)

      integer, intent(in)  :: limit
      integer :: count
      integer :: i, j

      allocate(isPrime(limit))
      isPrime = .true.
      primeCount = 0

      do i = 2, limit
        if (isPrime(i)) then              ! Have a new prime
          primeCount = primeCount + 1
          do j = i+i, limit, i            ! Multiples of this prime aren't prime.
            isPrime(j) = .false.
          end do
        end if
      end do
      count = primecount

    end function initPrimes
end module SieveEratosthenes


program progTwinPrimes
use SieveEratosthenes

implicit none
integer, parameter :: mxPrime = 10000000
integer :: ii

! Preset indicator array isPrime(*) using Sieve
ii = initPrimes (mxPrime)

! find prime twins thgat add up to a square number
!
do ii=3, mxPrime, 2   ! only consider odd numbers, 2 is only even prime.
  ! construct nested ifs because some compilers
  ! do not shortcut (a .and. b .and. c) when a or b is .false.
  if (isPrime(ii)) then
    if (isPrime (ii+2)) then
      if (isSquareNumber (ii+ii+2)) then
        print '(i0, "^2 = " ,i0, " = ", i0,"+",i0 )' , int (sqrt (dfloat (ii+ii+2))),   ii+ii+2  , ii, ii+2
      endif
    endif
  endif
end do

contains

! Returns true if integer n is a*a with integer a.
function isSquareNumber (n) result (yn)
  integer :: n
  logical :: yn
  integer :: root_n
  ! real(kind=8) can represent ALL 4-byte integers PRECISELY.
  real(kind=8)   :: r_root_n
  r_root_n = sqrt (dfloat(n))
  root_n = r_root_n
  yn =  (n .eq. root_n*root_n )

end function isSquareNumber

end  program  progTwinPrimes

