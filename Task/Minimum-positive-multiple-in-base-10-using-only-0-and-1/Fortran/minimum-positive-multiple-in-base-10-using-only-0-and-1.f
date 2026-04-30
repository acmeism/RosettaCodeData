!
! Minimum positive multiple in base 10 using only 0 and 1
! tested with GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!
! U.B., March 2026
!
program MinPosMul
implicit none

integer, parameter :: i128 = 16

integer (kind=i128) :: i

! 1-10 (inclusive)
do i = 1, 10
  call     test(i)
enddo

! 95-105 (inclusive)
do i = 95, 105
  call test(i)
enddo

call test(297_i128)
call test(576_i128)
call test(594_i128)      ! needs a larger number type (64 bits signed)
call test(891_i128)
call test(909_i128)
call test(999_i128)      ! needs a larger number type (87 bits signed)

! optional
call test(1998_i128)
call test(2079_i128)
call test(2251_i128)
call test(2277_i128)

! stretch
call test(2439_i128)
call test(2997_i128)
call test(4878_i128)

contains

subroutine test (n)

integer (kind=i128), intent(in) :: n
integer (kind=i128) :: mult

mult = mpm(n)
if (mult .gt. 0) then
  call print128(n)
  write (*,'(" * ")', advance='no')
  call print128(mult)
  write (*,'(" = ")', advance='no')
  call print128(n * mult)
  write (*,*)
else
  call print128(n)
  write (*,'("(no solution)")')
endif

end subroutine test



subroutine print128(n)
integer (kind=i128), intent(in) :: n
write (*,'(i0)', advance='no')  n
end subroutine print128


function mpm  (n)    result (returnvalue)
integer (kind=i128), intent(in)  ::n
integer (kind=i128) :: returnvalue
integer (kind=i128), dimension(:), allocatable  :: L
integer (kind=i128) ::m, k, r, j;

if (n .eq. 1) then
  returnvalue = 1
  return
endif

allocate (L(0:(n * n)-1))
L=0

L(0) = 1
L(1) = 1
m = 0
do
  m=m+1
  if (L((m - 1) * n + imod (-(10_i128** m), n)) .eq. 1) then
    exit
  endif
  L(m * n) = 1
  do k = 1, n-1
    L(m * n + k) =  max (L((m - 1) * n + k), L((m - 1) * n + imod(k - 10_i128** m, n)) )
  enddo
enddo

r = 10_i128 **  m
k = imod (-r, n)

do j = m - 1, 1, -1
  if (L((j - 1) * n + k) .eq. 0) then
    r = r + 10_i128 **j
    k = imod(k - 10_i128 ** j, n)
  end if
end do

if (k .eq. 1) then
        r=r+1
endif
returnvalue =  r / n

deallocate (L)
end function mpm

pure function imod (m,n) result (returnvalue)
integer (kind=i128), intent(in) :: m, n
integer (kind=i128) :: returnvalue

returnvalue = mod(m,n)
if (returnvalue .lt. 0) returnvalue = returnvalue + n
end function imod

end program MinPosMul
