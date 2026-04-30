!
! Calkin-Wilf sequence
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program CalkinWilf

implicit none
integer, parameter :: tInt=8, tReal=8      ! We use this for integer and Real numbers

type Rational
  integer(kind=tInt) :: numerator
  integer(kind=tInt) :: denominator
end   type Rational

! A simple dynamic array that can grow as new values get inserted
type vect
  integer(kind=tInt), dimension(:), allocatable :: Values
  integer :: capacity=0
  integer :: current=0
end type vect

Type(Rational) :: cwNum
integer:: idx

call printFirstTerms (20)

! find the index of 83116 / 51639 within the sequence
cwNum%numerator = 83116
cwNum%denominator = 51639

idx =  term_Number (cwNum)
write (*, '(/,"83116 / 51639 is the ", i0, "th term of the sequence.")') idx

contains



! ==============================================================================================
! Calculate the first 'n' values of the Calkin-Wilf sequence as rational numbers and print them .
! ==============================================================================================
subroutine printFirstTerms (n)
integer :: n
integer :: I

cwNum%numerator = 1
cwNum%denominator = 1
write (*,'("First ",i0," terms of the Calkin-Wilf sequence are: ")') n
do i=1, n
  call printRational (i, cwNum)
  cwnum = nextInSeq(cwnum)
end do
end subroutine printFirstTerms

! ==================================================================================
! Formatted print function for rational number r, appearing at pos k in our sequence
! ==================================================================================
subroutine printRational (k,r)
integer, intent(in) :: k
type(Rational), intent(in) :: r

write (*, '(i2, ": ",i0,x,"/",x,i0)') k, r%numerator, r%denominator

end subroutine printRational

! ==============================================================
! Calculate the index int the Calkin-WIlf sequence for element R
! ==============================================================
function term_Number (R)  result (res)

type(Rational), intent(in) :: r
integer (kind=tInt) :: res
integer (kind=tInt) :: d, p, n, idxn, i

type (vect) :: cf                   ! will contain the continued fraction

res = 0
d = 1
p = 0
call continued_fraction (r, cf)
do idxn=1, cf%current               ! Set the bits of the result value
  n = cf%values(idxn)
  do i = 0,  n-1
    res = ior (res, ishft (d, p))
    p = p + 1
  enddo
  d = 1-d      ! After setting bits, we skip bits and after skipping bits, we set bits.
enddo
end function term_Number

! ======================================================================================
! Calculate the continued fraction 'cf' from rational number 'r'
! (This is basically Euclid's gcd algorithm, in which we store the intermediate results)
! ======================================================================================
subroutine continued_fraction (r, cf)
type (Rational), intent(in) :: r
type (vect), intent(inout) :: cf

integer (kind=tInt) :: a, b, c
a = r%numerator
b = r%denominator
do   while (a .ne. 1)
  call push_back (cf, a/b)
  c = A
  a = b
  b = mod (c, b)
enddo

! Care for an odd number of terms in the continued fraction.
if (cf%current .gt.0) then                                ! Any elements?
  if (mod (cf%current,2) .eq. 0) then                     ! Even number of entries?
    cf%Values(cf%current) = cf%Values(cf%current)-1       ! Decrement last entry and
    call push_back (cf, 1_tInt)                           ! insert an additional 1
  endif                                                   ! No else: it's odd as it should.
end if
end subroutine continued_fraction


! ===========================================
! Insert a new value to the end of the vector
! ===========================================
subroutine push_back (V, value)
type (vect), intent(inout) :: V
integer(kind=tInt) :: value

V%current = V%current + 1
if (V%current .gt. V%capacity) then                       ! Extend Vector if necessary
  call alloc (V, 2*V%capacity)
endif
V%values(V%current) = value
end subroutine push_back

! ==============================
! Resize vector "V" to "newSize"
! ==============================
!
subroutine alloc (V,newSize)
type (vect), intent(inout) :: v           ! The Vector to extend
integer,intent(in) :: newSIze             ! the new size
integer  :: n                             ! the new size

integer (kind=tInt), dimension(:), allocatable :: tmp ! Temporary during extension

! at the very first allocation (from push_back(), the "newSize" might be 2*0=0
! Make sure we alloc space for at least 1 element, not 0
!
n = max (newSize, 1)
if (n .gt. v%capacity) then               ! Only if its a real extension
  if (v%capacity .gt. 0) then             ! not for very first allocation
    ! call move_alloc (v%values, tmp)     ! Copy to tmp, F 2003, not for FSI Fortran
    allocate (tmp(v%capacity))            ! FOr compatibility with F95, write some extras lines
    tmp (:v%capacity) = v%values(:v%capacity)
    deallocate (v%values)
  endif
  allocate (v%values ( n))                ! Allocate new size
  if (.not. allocated (v%values)) then    !check if allocation went OK
    print *, 'FATAL:  ALLOC FAILED.'
  endif

  if (allocated (tmp)) then               ! must copy Old values from tmp to V?
    v%Values(:v%capacity) = tmp (:v%capacity)
    deallocate (tmp)
  endif
  v%capacity = n
endif                                     ! No Else, no decrease size.

end subroutine alloc

! ===================================================================================================
! Calculate floor (numerator/denominator) and return result as new rational number with denominator 1
! ===================================================================================================
function Rfloor (R) result (F)
type(Rational), intent(in) :: R
type(Rational)  :: F

! numerator and denominator are integers. Do it simply without converting to reals and
! cutting of decimal fraction after the division.
F%numerator = R%numerator / R%denominator
F%denominator = 1

end function Rfloor

! ===========================================
! Arithmetic operatinos with Rational Numbers
! ===========================================
!
! a + b
!
function add (a, b) result (sum)
type(Rational), intent(in) :: a, b
type(Rational) :: sum

sum%numerator   = a%numerator * b%denominator + b%numerator * a%denominator
sum%denominator = a%denominator * b%denominator

end function add
!
! a - b
!
function sub (a, b) result (dif)
type(Rational), intent(in) :: a, b
type(Rational) :: dif

dif%numerator   = a%numerator * b%denominator - b%numerator * a%denominator
dif%denominator = a%denominator * b%denominator

end function sub

!
! a * b
!
function mul (a,b) result (prod)
type(Rational), intent(in) :: a, b
type(Rational) :: prod

prod%numerator = a%numerator*b%numerator
prod%denominator = a%denominator*b%denominator

end function mul

!
! 1 / a
!
function inv (a) result (inva)
type(Rational), intent(in) :: a
type(Rational) :: inva

inva%numerator = a%denominator
inva%denominator = a%numerator
end function inv

! =======================================================
! Calculate next value in the sequence from current value
! following the definition of the Calkin-Wilf sequence
! =======================================================
function nextInSeq (Cur) result (nxt)
type (Rational), intent(in) :: Cur
type (Rational) :: nxt

type (Rational) :: a,b,c          ! Store intermediate values
type (Rational) :: two, one       ! constants 1/1 and 2/1

one%numerator = 1
one%denominator = 1
two%numerator = 2
two%denominator = 1

! Use variables for intermediate values.
! This is equivalent to the more compact but unreadable
!
! nxt = inv (sub(add( mul(two,RFloor(cur)), one),cur))
!
a   = mul(two, Rfloor(cur))
b   = add (a, one)
c   = sub (b, cur)
nxt = inv(c)

end function nextInSeq

end program CalkinWilf
