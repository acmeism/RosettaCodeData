!
! Frobenius Numbers
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
!

module  SieveEratosthenes
  implicit none

  logical, allocatable :: isPrime(:)
  integer, allocatable :: primes(:)
  integer :: primeCount

  contains

    function initPrimes (limit)  result (count)

      integer, intent(in)  :: limit
      integer count
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
      allocate (primes(primeCount))

      j = 1
      do i = 2, limit
        if (isPrime(i)) then
          primes(j) = i
          j = j + 1
        end if
      end do
    end function initPrimes
end module SieveEratosthenes


program Frobenius
use SieveEratosthenes

implicit none
integer, parameter :: NMax = 1000000
integer :: ii, jj, Frob, nPrimes
character PrimeIndicator

! Preset prime numbers using Sieve
! Since we want to probe if Frob(n) is prime, we need to
! know all primes up to maximum Frobe(n).
! Otherwise not just sqrt (NMax)+1

nPrimes = initPrimes (nMax)          ! returns true count of primes

write (6,'(" Frobenius numbers less than ", i0, " (asterisk marks primes):")') nMax
ii = 1
Frob = 0
do while (frob .le. NMax)
  do jj=0, 9
    if ((ii+jj) .le. nPrimes) then
      Frob = primes(ii+jj)*primes(ii+jj+1)-primes(ii+jj)-primes(ii+jj+1)
      if (Frob .gt. NMax) then
        exit
      endif
      if (isPrime (Frob)) then
        PrimeIndicator = '*'
      else
        PrimeIndicator = ' '
      endif
      write (6, '(i7,a1)', advance='no') Frob, PrimeIndicator
    end if
  end do
  write (6,*)
  ii = ii + 10
end do

end  program  Frobenius

