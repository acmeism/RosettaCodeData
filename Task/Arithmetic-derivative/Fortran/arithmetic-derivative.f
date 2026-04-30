! Arithmetic derivative
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3

program AriDeri

implicit none

integer, parameter :: limit=100
integer :: i, nInOneLine
character (len=50) :: powD
character (len=50) ::form
! First part: D(n) for n=-99...100
nInOneLine = 0
Write (*,'(A)')   ' D(k), k=-99...100:'
Write (*,'(A,/)') ' =================='
do i=-99,limit
  write (*,'(I4)', advance='no')  arithmeticDerivative (i)
  nInOneLine = nInOneLine + 1
  if (nInOneLine .eq. 10) then
    write (*,*)
    nInOneLine = 0
  endif
enddo
write (*,*)

! Second part:
! 1/7 * D(10^n) for n=1, 20
!
! We know that D(10) = 7, and we have the rule D(a*b) = a*D(b)+b*(D(a)
! so D(10*10)  = 10*D(10) + 10*D(10) = 140, D(100) = 140,          and D(100)/7  =  20
!    D(10*100) = 10*D(100) + 100*D(10) = 10*140 + 100*7 = 2100,    and D(1000)/7 = 300
! This can be continued,by induction:
! knowing 1/7 * D(10^k), we get for 1/7 * D(10^(k+1)) :
! 1/7 * D(10^k+1) = 1/7 * (D(10^k)*10 + 10^k*D(10))
!                 = 1/7 * (D(10^k)*10 + 10^k* D(10)) = 1/7 * (D(10^k)*10 + 10^k*7)
!                 = 1/7*10*D(10^k) + 1/7*(10^k)*7)
!                 = 10*1/7*D(10^k) + 10^k
! The sequence is 1, 10+10=20, 200+100=300, 3000+1000=4000,40000+10000=50000, etc.
! Hence we dont need to calculate with big integers, but just count 1..20 and append 0...19 zeroes.
!
write (*,'(A)') 'D(10^k) / 7, k=1...20'
write (*,'(A,/)') '====================='
do i=1,20
  ! variable format to write to string powD the Numbers 1...20, followed by (0...19) * '0'
  if (i .gt. 1) then
    write (form, '("(I0,", i0, "(""0""))" )')  i-1
  else
    form = '(I0)'
  endif
  powD = ' '
  write (powd, form) i
  write (*,'("D(10^",i2,") / 7 = ",A)')  i, powd
enddo
contains

function arithmeticDerivative (argn) result (r)

integer, intent(in) :: argn
integer :: r

integer :: n, sum, count, m
integer :: p, sq

if (argn .ge. 0) then       ! for n<0 we have D(n) = -D(-n)
  n = argn
else
  n = -argn                 ! Calculate D(-n) and return -D(-n) later.
endif

if (n .lt. 2) then          ! Early return for smallest n
  r = 0
  return
endif

sum=0
count=0
m=n

do while (mod(m,2) .eq. 0)
  m = m/2
  count = count + n
enddo
if (count .gt. 0)    sum=sum+count/2

p = 3
sq = 9

do while (sq .lt. m)
  count = 0
  do while (mod (m, p) .eq. 0)
    m = m / p
    count = count + n
  enddo
  if (count .gt. 0) sum = sum + count/p
  sq = sq + 2*(p+1)
  p = p + 2
end do
if (m .gt. 1) sum = sum + n/m

if (argn .lt. 0) sum = -sum

r = sum

end function arithmeticDerivative
end program AriDeri
