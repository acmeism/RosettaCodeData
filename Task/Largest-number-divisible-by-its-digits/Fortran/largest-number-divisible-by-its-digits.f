!
! Largest number divisible by its digits
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program LargestDivisibleByDigits

implicit none

integer , parameter ::i64 = 8             ! Kind for 64-bit integers

call findLargestBase10()
call findLargestBase16()

contains

! ========================================================
! Find the largest number divisible by its digits, decimal
! ========================================================
subroutine findLargestBase10 ()
! Answer cannot contain a digit 0 for obvious reason: so no 10-digit result.
! Answer cannot be a multiple of 5, so all 9-digit numbers are ruled out.
! Answer cannot be a permutation of digits 98764321 because the digit sum is 40, so not divisible by 3,
! hence all 8-digit numbers are ruled out.
integer, parameter :: divisor=9*8*7       ! answer must be a mutliple of this (also covers 1,2,3,4)
integer, parameter :: high = 9876432      ! max 7 digit number divisible by 3 with unique digits and no 5|0
integer :: I

i=high-mod(high,divisor)                  ! highest multiple of divisor
do while ( .not. checkDec(i))
  i = i - divisor
end do
write (*,'("The largest     decimal Lynch-Bell number is ", i0)')  I

end subroutine findLargestBase10


! ============================================================
! Find the largest number divisible by its digits, hexadecimal
! ============================================================
subroutine findLargestBase16 ()

integer(kind=i64), parameter :: hex_divisor = 15 * 14 * 13 * 12 * 11

integer(kind=i64) :: hexadecimal

hexadecimal = int ( Z'fedcba987654321', kind=i64) / hex_divisor  * hex_divisor
do while ( .not.  checkHex(hexadecimal) )
  hexadecimal = hexadecimal - hex_divisor;
enddo
write (*, '("The largest hexadecimal Lynch-Bell number is ", z15, " = ", i0)')  hexadecimal, hexadecimal
end subroutine findLargestBase16

! ================================================================
! Check if a number n can evenly be divided by its digits, base 16
! ================================================================
function checkHex (n) result (YN)

integer(kind=i64), intent(in) :: n
logical :: YN

integer (kind=1), dimension(15) :: indicator        ! shows if any of the digits appears twice
character (len=15) :: hex_string
integer :: ii, idx

! Convert input to hexadecimal representation
write (hex_string,'(Z15)')   n

YN = .true. ! Assume all's good.

! Early return if any digit is 0
if (index (hex_string, '0') .ne. 0) then
  YN = .false.
  return
endif

indicator = 0
do ii=1, 15                                           ! Go through all hex digits
  if (hex_string(ii:ii) .ne. ' ') then                ! Could be blank if less than 15 digits
    if (hex_string(ii:ii) .ge. 'A' ) then             ! convert letters 'A'...'F' to numbers 10...15
      idx = ichar(hex_string(ii:ii)) -ichar('A') + 10
    else
      idx = ichar(hex_string(ii:ii)) -ichar('0')      ! Otherwise convert letters '0'...'9' to 0...9
    endif
    ! Check this digit appears second time, if so: Early Return with result FALSE
    indicator (idx) = indicator(idx) + 1
    if (indicator(idx) .gt. 1) then                        ! Digit appears 2nd time
      YN = .false.
      return
    endif

    ! Check if this digit divides n
    if (mod (n, idx) .ne. 0) then                     ! Digit does not divide n
      YN = .false.
      return
    endif
  endif
enddo
end function checkHex

! ================================================================
! Check if a number n can evenly be divided by its digits, base 10
! ================================================================
function checkDec (k) result (YN)
integer, intent(in) :: k
logical :: YN
integer :: kk,d
integer (kind=1), dimension(0:9) :: indicator

indicator=0
kk = k
YN=.true.
!
do while (kk .gt. 0)
  d = mod(kk,10)
  if (d .eq.0) then
    YN = .false.
    exit
  endif
  kk = kk / 10
  if (mod(k,d) .ne. 0) then
    YN=.false.
    exit
  endif
  if (indicator(d) .ne. 0) then
    YN=.false.
    exit
  endif
  indicator(d)=1
enddo

end function checkDec

end program LargestDivisibleByDigits
