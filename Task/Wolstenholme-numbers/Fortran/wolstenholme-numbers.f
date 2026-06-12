!
! Wolstenholme numbers
! tested with GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
! U.B., May 2026
!
program Wolstenholme

implicit none
integer, parameter :: tInt=16                ! We need to calculate with large integers

type Rational
  integer(kind=tInt) :: numerator
  integer(kind=tInt) :: denominator
end   type Rational

call printFirstTerms (20)

contains



! ======================================================================================
! Calculate the first 'n' values of the Wolstenholme numbers and print their numerators.
! ======================================================================================
subroutine printFirstTerms (n)
integer, intent(in) :: n
Type(Rational) :: oneOverkSquared       ! 1/(k^2)
Type(Rational) :: wNum                  ! The Wolstenholme numbers to calculate
integer :: i                            ! Loop index

wNum%numerator = 1                      ! Initalize 1st W-Num
wNum%denominator = 1

oneOverkSquared%numerator = 1           ! is always 1, only denominator changes

write (*,'("First ",i0," denominators of the Wolstenholme numbers are: ", /, " 1: 1")') n
do i=2, n
  oneOverkSquared%denominator = i*i
  wNum = add (wNum, oneOverkSquared)
  if (isPrime (wNum%numerator)) then
    write (*, '(i2, ": ",i0, T30, "Is prime" )') i, wNum%numerator
  else
    write (*, '(i2, ": ",i0 )') i, wNum%numerator
  endif
end do
end subroutine printFirstTerms



! ===========
! sum = a + b
! ===========
function add (a, b) result (sum)
type(Rational), intent(in) :: a, b
type(Rational) :: sum
integer (kind=tInt) :: bdg, adg,  g


! Avoid overflow while calculating the resultant rational number by first reducing the denominators by their gcd.
!    since gcd (a%numerator,a%denominator) .eq. 1 AND  ALSO gcd (b%numerator,b%denominator) .eq. 1, only
!          gcd (a%denominator, b%denominator) can be .gt. 1.
g = gcd (a%denominator, b%denominator)

sum%numerator   = a%numerator * (b%denominator/g) + b%numerator * (a%denominator/g)
sum%denominator = a%denominator * b%denominator/g

call reduce (sum)
end function add

! ================================================
! Divide numerator and denominator by gcd of them.
! ================================================
subroutine reduce (r)
type(Rational), intent(inout) :: r
integer (kind=tInt) :: g

g = gcd (r%numerator, r%denominator)
r%numerator = r%numerator / g
r%denominator = r%denominator / g

end subroutine reduce


! ===============================
! euclid's algorithm
! to find greatest common divisor
! ===============================
function gcd (n,m) result (rgcd)

integer (kind=tInt), intent(in) :: n,m
integer (kind=tInt)             :: rgcd
integer (kind=tInt)             :: a, b, h

a=n     ! Have mutable copies of intent(in) arguments
b=m
do while (b .ne. 0)
  h = mod (a,b)
  a = b
  b = h
end do
rgcd =a
end function gcd
  ! ----------------------------------------
  ! Miller-Rabin test if n is a prime number
  ! ----------------------------------------
  function isPrime(n) result (YN)

  integer(kind=tInt), intent(in) ::n
  logical :: YN
  integer (kind=tInt) :: ar (9), i

  ! Early return in most trivial cases
  if (n .le. 1) then      ! Too small
    YN=.false.
    return
  endif
  if (n .eq. 2) then      ! 2 is prime
    YN=.true.
    return
  endif
  if (mod (n , 2) .eq. 0) then    ! all other even number are not prime
    YN=.false.
    return
  endif
  if (n .lt. 9) then              ! all odd numbers < 9 are prime
    YN=.true.
    return
  endif
  if (mod (n , 3) .eq. 0) then    ! multiples of 3 aren't prime
    YN=.false.
    return
  endif
  if (mod (n , 5) .eq. 0) then    ! multiples of 5 aren't prime
    YN=.false.
    return
  endif


  if (n .lt. 2047	) then
    ar(1) = 2
    if (Witness(ar(1), n)) then
      YN=.false.                  ! Not prime
      return
    endif
  else if (n .lt. 1373653) then
    ar(1) =  2
    ar(2) = 3
    do i = 1, 2
      if (Witness(ar(i), n)) then
        YN=.false.                  ! Not prime
        return
      endif
    end do
  else  if (n .lt. 2152302898747_tInt) then

    ! these 5 bases are required and sufficient to test numbers up to 2,152,302,898,747	
    ar(1) =  2
    ar(2) = 3
    ar(3) = 5
    ar(4) = 7
    ar(5) = 11
    do i = 1, 5
      if (Witness(ar(i), n)) then
        YN=.false.                  ! Not prime
        return
      endif
    end do
  else if (n .lt. 3825123056546413051_tInt) then
    ! these bases are sufficient for numbers up to 3.825.123.056.546.413.051
    ! 2, 3, 5, 7, 11, 13, 17, 19, 23
    ar(1) = 2
    ar(2) = 3
    ar(3) = 5
    ar(4) = 7
    ar(5) = 11
    ar(6) = 13
    ar(7) = 17
    ar(8) = 19
    ar(9) = 23
    do i=1,9
      if (Witness(ar(i), n)) then
        YN=.false.                  ! Not prime
        return
      endif
    enddo
  endif

  YN= .true.                      ! prime

  end function isPrime

  ! -------------------------------------
  ! helper function for Miller Rabin test
  ! -------------------------------------
  function Witness(a, n) result (YN)

  integer (kind=tInt) , intent(in) :: a
  integer (kind=tInt)  , intent(in) :: n


  integer (kind=tInt) :: t, u, i
  logical :: YN
  integer (kind=max(8,tInt))  :: xi1, xi2

  t = 0
  u = n - 1
  do while (iand(u , 1_tInt) .eq. 0)
    t = t + 1
    u = u / 2
  end do

  xi1 = ModularExp(a, u, n)
  do i = 0, t-1
    xi2 = mod (xi1 * xi1 , n)
    if ((xi2 .eq. 1) .and. (xi1 .ne. 1) .and.  (xi1 .ne. (n - 1))) then
      YN = .true.
      return
    endif
    xi1 = xi2
  end do
  if (xi1 .ne. 1) then
    YN=.true.
  else
    YN = .false.
  endif
  end function Witness

  ! -------------------------------------
  ! helper function for Miller Rabin test
  ! -------------------------------------
  function ModularExp(a, b, n)  result(d)
  !
  ! (a^b) mod n
  !
  integer(kind=tInt) , intent(in) :: a,b,n
  integer (kind=tInt) :: d
  integer (kind=tInt) :: i, k
  d = 1
  k = 0
  do while (ishft (b, -k) .gt. 0)
    k = k + 1
  end do
  do i = k - 1, 0, -1
    d = mod (d*d, n)
    if (iand (ishft (b, -i) , 1_tInt) .gt. 0) d = mod (d*a ,n);   ! OVERFLOW HAPPENS in d*a!
  end do

  end function ModularExp

end program Wolstenholme
