! Fermat pseudoprimes
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
program PseudoPrimes

implicit none

integer , parameter :: maxX(4) = [12000, 25000,50000,100000], maxA=20
integer , dimension(maxX(4)) :: isPrime
integer  :: a          ! Base
integer  :: x          ! PseudoPrime?
logical :: printThem
integer  :: pseudoPrimeCount
integer  :: ii

call setupPrimes (isPrime, maxX(4))

! Part 1: first 20 Pseudo primes for base 1...20
!
write (*,'("First 20 Fermat Pseudo Primes:")')
do a=1,maxA             ! Try all bases
  write (*, '("Base ", i2,": ")', advance='no')  a
  pseudoPrimeCount = 0
  x = 4
  do while (pseudoPrimeCount .lt. 20)
    if (isFermatPseudoPrime (a, x)) then
      pseudoPrimeCount = pseudoPrimeCount + 1
      write (*, '(X, I5)', advance='no')   x
      if (pseudoPrimeCount .eq. 10) then
        write (*, '(/, 9x)', advance='no')
      else if (pseudoPrimeCount .eq. 20) then
        write (*,*)
      endif
    endif
    x = x + 1
  end do
  write (*,*)
enddo

! Part 2: Count up to limits 12000, 25000,50000,100000 and bases 1...20
write (*,'("Count of Fermat Pseudo Primes up to limits:")')
write (*,'("Limit:",3x,4i15)') 12000, 25000,50000,100000

do a=1,maxA
  write (*, '("Base ", i2,": ")', advance='no')  a
  pseudoPrimeCount = 0
  x = 4
  do ii=1, 4
    pseudoPrimeCount = 0
    do x=4, maxX(ii)
      if (isFermatPseudoPrime (a,x)) then
        pseudoPrimeCount = pseudoPrimeCount + 1
      endif
    enddo
    write (*, '(I15)', advance='no')   pseudoPrimeCount
  end do
  write (*,*)
enddo


contains

! ===============================================
! Decide if x is a Fermat Pseudo Prime in base a.
! ===============================================
function isFermatPseudoPrime (a, x) result (yn)
integer , intent(in) :: a, X
logical :: yn

yn = .true.                           ! Assume it is.
if ( isPrime (x) .ne. 0 ) then
  yn = .false.                        ! x is a prime number so its not pseudo-prime
endif
if ( modpow (a,x-1,x) .ne. 1 ) then
  yn = .false.                        ! x does not divide (a^(x-1))-1, not pseuidoprime.
end if

end function isFermatPseudoPrime


! =======================================
! Calculate mod (argbase ** argexp ,modX)
! =======================================
function  modpow ( argbase, argexp, modX) result (retval)

integer , intent(in) :: argbase, argexp, modX
integer   :: retval

! While the return value and the arguments are int32, this function internally
! calculates large numbers (products of 2 integers, before applying the modulus), so
! overflows can occur if local variables were int32 only. So for all internal
! calculation we use int64 variables.
!
integer,  parameter :: int64 = 8
!
integer (kind=int64) :: mp
integer (kind=int64) :: base, exp

base = argbase  ! We need mutable int64 copies of the arguments because we want to modify that value
mp = 1
base = mod (base,modX)
exp = argexp

do while (exp .gt. 0)
  if (mod (exp,2)  .eq. 1) then
    mp = mod (mp * base, modX)
  endif
  base = mod(base*base, modX)
  exp = exp / 2
end do
retval = mp
end function modpow

! =======================================================================
! Setup array p with n entries, indicating p(k)=1 if k is a prime, else 0
! =======================================================================
subroutine setupPrimes (p,n)
integer , intent(in) :: n
integer , dimension(n), intent(out) :: p

integer  :: i, j

p = -1
p(1) = 0

do i=2,n
  if (p(i) .eq. -1) then
    ! i is a prime number
    p(i) = 1
    ! All multiples of i are not prime.
    do j=i+i,n,i
      p(j) = 0
    enddo
  endif
enddo
end subroutine setupPrimes

end program PseudoPrimes

