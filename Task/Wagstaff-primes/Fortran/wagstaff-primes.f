!
! Wagstaff primes
! tested with GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
! U.B., June 2026
!
program Wagstaff

implicit none
integer, parameter :: tInt=16                   ! Going to calculate with some really large integers

integer (kind=tInt) :: m
integer (kind=tInt) :: p

do p=3, (8*tInt-2), 2                           ! must be less than (8*16-1) bits (sign bit unused)
  if (isPrime(p)) then
    m = (2_tInt ** p + 1_tInt) / 3_tInt
    if (isPrime (m)) then
      write ( *,'("p = ", i3, 3x, "m = ", i0)')  p, m
    endif
  end if
enddo

contains

! ----------------------------------------
! Miller-Rabin test if n is a prime number
! ----------------------------------------
function isprime(n) result (YN)
integer(tInt), intent(in) :: n
logical :: YN

integer(tInt) :: d
integer :: s, i

integer(tInt), parameter :: bases(*) = [ &
        2_tInt, 3_tInt, 5_tInt, 7_tInt, 11_tInt, &
        13_tInt, 17_tInt, 19_tInt, 23_tInt, 29_tInt, &
        31_tInt, 37_tInt, 41_tInt]
if (n < 2_tInt) then
  YN = .false.
  return
end if

if (n == 2_tInt .or. n == 3_tInt) then
  YN = .true.
  return
end if

if (mod(n,2_tInt) == 0) then
  YN = .false.
  return
end if

! n-1 = d * 2^s
d = n - 1
s = 0

do while (mod(d,2_tInt) == 0)
  d = d / 2
  s = s + 1
end do

do i = 1, size(bases)
  if (bases(i) >= n) cycle
  if (witness(bases(i), n, d, s)) then
    YN = .false.
    return
  end if
end do

YN = .true.
end function isprime



! -------------------------------------
! helper function for Miller Rabin test
! -------------------------------------
function witness(a,n,d,s) result (YN)
integer(tInt), intent(in) :: a,n,d
logical :: YN

integer, intent(in) :: s

integer(tInt) :: x
integer :: r

x = powmod(a,d,n)

if (x == 1_tInt .or. x == n-1) then
  YN = .false.
  return
end if

do r = 1, s-1
  x = mulmod(x,x,n)
  if (x == n-1) then
    YN = .false.
    return
  end if
end do

YN = .true.
end function witness

!---------------------------------------------------------
! a^e mod m
!---------------------------------------------------------
function powmod(a,e,m) result(r)
integer(tInt), intent(in) :: a,e,m
integer(tInt) :: r
integer(tInt) :: base, expn

r = 1_tInt
base = mod(a,m)
expn = e

do while (expn > 0)
  if (iand(expn,1_tInt) /= 0) then
    r = mulmod(r, base, m)
  end if
  base = mulmod(base, base, m)
  expn = ishft(expn,-1)
end do
end function powmod



!---------------------------------------------------------
! a*b mod m, avoiding overflow
!---------------------------------------------------------
function mulmod(a,b,m) result(r)
integer(tInt), intent(in) :: a,b,m
integer(tInt) :: r
integer(tInt) :: x,y

r = 0_tInt
x = mod(a,m)
y = b

do while (y > 0)
  if (iand(y,1_tInt) /= 0) then
    r = mod(r + x, m)
  end if
  x = mod(x + x, m)
  y = ishft(y,-1)
end do

end function mulmod


end program Wagstaff
