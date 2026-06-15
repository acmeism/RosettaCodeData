!
! Prime triplets
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., June 2026
program PrimeTripletsOfThree

implicit none

integer, parameter :: tInt=4                                      ! Small problem, small integers
! TripletsOfThree uses : integer(kind=tInt), parameter ::limit = 6005_tInt                 ! largest prime number we need
integer(kind=tInt), parameter ::limit = 5505_tInt            ! largest p+6 if  prime p<5500
integer(kind=tInt), dimension(:), allocatable :: primes
integer(kind=tInt) :: ii
integer(kind=tInt) :: highPrimes

integer :: count, count1B, NumbersInLine

call SievePrimes (limit)
! TripletsOfThree uses :  write (*, '("   n    n-1  n+3  n+5",/,"---------------------")')
write (*, '("    p  p+2  p+6 ",/,"-----------------")')
do ii=1,  highPrimes-2                                            ! so that primes(ii+2) can be addressed
  ! TripletsOfThree uses : if (      primes(ii+1) .eq. primes(ii)+4 &                      ! next prime is 4 larger than current one
  ! TripletsOfThree uses : .and. primes(ii+2) .eq. primes(ii)+6  ) then                ! and second next is 6 larger: n = primes(ii)+1
  ! TripletsOfThree uses : write (*, '(i4,": ", 3i5)' )  primes(ii)+1, primes(ii), primes(ii+1), primes(ii+2)
  if (      primes(ii+1) .eq. primes(ii)+2 &                      ! next prime is 2 larger than current one
      .and. primes(ii+2) .eq. primes(ii)+6  ) then                ! and second next is 6 larger: n = primes(ii)+1
    write (*, '(3i5)' )   primes(ii), primes(ii+1), primes(ii+2)
  endif

end do

contains

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

end program PrimeTripletsOfThree
