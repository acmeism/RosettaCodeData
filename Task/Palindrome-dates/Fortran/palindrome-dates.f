!
! Palindrome dates
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program PalindromeDates
implicit none

integer :: yyyy, mm, dd
integer :: nPals=0

yyyy=2030                                           ! Start value, for 1st palindromic date after 2020-02-02

do while (nPals .lt. 15 .and. yyyy .lt. 10000)      ! year 10000 would produce run-time error
  call yyyytommdd (yyyy,mm,dd)                      ! calculate mm,dd from yyyy so that yyyymmdd is a palindrome
  if (isPlausibleDate (yyyy,mm,dd)) then            ! exclude invalid dates such as 2031-13-02 or 4321-12-34
    write (*, '(I4,"-",i2.2,"-",i2.2)') yyyy,mm,dd  ! print the rest: valid palindromic dates
    nPals = nPals + 1                               ! Count valid palindromic dates
  end if
  yyyy = yyyy+1                                     ! Try again next year
enddo

contains


! =========================================
! Decide if a given date Y-m-d is plausible
! =========================================
function isPlausibleDate (y,m,d) result (YN)
integer, intent(in) :: y,m,d
logical :: YN

! Max number of Days in each month, Feb is 29 in leap years only.
integer, dimension(12),parameter :: nDays =[31,29,31,30,31,30,31,31,30,31,30,31]

YN = .false.

if (m .lt. 1 .or. m .gt. 12) then           ! Impossible Month
  return                                    ! Early return .false.
endif

if (d .lt. 1 .or. d .gt. nDays(m)) then     ! Impossible day
  return                                    ! Early return .false.
endif

! Special case: feb-29
if (m .eq. 2 .and. d .eq. 29) then        ! 20-Feb: only OK if Y is a leap year
  ! Check for leap year
  if (isLeapYear (y)) then
    YN = .true.                           ! in a leap year, Feb 29 is correct date
  else
    return                                ! Early return .false.
  endif
endif
!
! Any date not excluded by now is plausible.
!
YN = .true.

end function isPlausibleDate


! ===============================
! Decide if year y is a leap year
! ===============================
function isLeapYear (y) result (YN)
integer, intent(in) :: y
logical :: YN
!
! Rule: A year is a leap year if it is divisible by 4,
!       unless it is divisible by 100 but not by 400.
! e.g. 1900 is NOT a leap year
YN = (mod (y, 4) .eq. 0 .and. (mod(y, 400) .eq. 0 .or. mod(y, 100) .ne. 0))

end function isLeapYear

! =====================================================================
! calculate month m,day d from year y so that yyyymmdd is a palindrome
! =====================================================================
subroutine yyyytommdd (y,m,d)
integer, intent(in) :: y
integer, intent(out) :: m,d

character(len=4) strYear, raeYrts


write (strYear, '(i4)')   y       ! Convert integer Year to string
raeYrts = reverse (strYear)       ! reverse order of characters in strYear so that strYearraeYrts is palindrome
read (raeYrts, '(i2,i2)')   m, d  ! extract integer month m and day d from reversed year

end subroutine yyyytommdd

! ==========================================================================
! return a 4-letter string in the reverse order of its letters: abcd -> dcba
! ==========================================================================
function reverse (chr) result(rhc)
character (len=4), intent(in) :: chr
character (len=4) :: rhc
integer :: ii

do ii=1, 4
  rhc(ii:ii) = chr (5-ii:5-ii)
enddo

end function reverse

end program PalindromeDates
