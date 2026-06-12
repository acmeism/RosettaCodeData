  ! Honaker Primes
  ! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
  !             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
  !             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
  ! Note that VMS requires switch $Fortran/ccdefault=LIST
  ! otherwise 1st character of each output line is interpreted as
  ! Carriage Control character.
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

module modHonaker
  use SieveEratosthenes

  implicit none

  integer :: idxPrime=1, idxHonakerPrime=0    ! initialize them for 1st call nextHonakerPrime

  contains

    subroutine nextHonakerPrime (iprime, iHonPrime, honPrime)
      integer, intent(out)  :: iPrime, iHonPrime, honPrime

      idxHonakerPrime = idxHonakerPrime + 1
      ! not: do while (idxPrime .le. primeCount .and. digitsum (idxPrime) .ne. digitsum (primes(idxPrime)))
      ! because not all compilers use shortcuts when evaluating a .and. b
      do while (idxPrime .le. primeCount)
        if ( digitsum (idxPrime) .eq. digitsum (primes(idxPrime))) then
          EXIT                      ! found next honaker prime, enough done.
        else
          idxPrime = idxPrime + 1   ! try next prime.
        end if
      end do
      iprime = idxPrime
      idxPrime = idxPrime + 1     ! for next use
      iHonPrime = idxHonakerPrime
      honPrime = primes(iPrime)

    end subroutine nextHonakerPrime

    ! calculate digit sum
    function digitsum (n) result (ds)
      integer, intent(in) :: n
      integer :: nn, d
      integer:: ds
      ds = 0
      nn = n
      do while (nn .ne. 0)
        d = mod (nn, 10)
        ds = ds + d
        nn = nn / 10
      end do
    end function digitsum

end module modHonaker


program progHonaker
  use SieveEratosthenes
  use modHonaker

  implicit none

  integer:: n, i, ihp,ip,np

  n = initPrimes (5000000)      ! higher than expected 10000th Honaker prime.

  write (6,'(a)' ) "The first 50 Honaker primes in triples #n: (PrimeIndex, PrimeNumber) are:"

  do i=1,50
    call nextHonakerPrime (ip,ihp,np)
    if (i .gt. 1 .and. mod(i,5) .eq. 1) then    ! new line after each set of 5 results
      write (6,*)
    end if
    write (6, '(i2,": (", i3, ",",i4,")    ")', advance='no' ) ihp, ip, np
  end do

  write (6,'(//"and the 10000th: ")', advance='no')
  do i=51,10000
    call nextHonakerPrime (ip,ihp,np)
  end do
  write (6,'("(", i6, ",", i7,")")')  ip, np
end program progHonaker
