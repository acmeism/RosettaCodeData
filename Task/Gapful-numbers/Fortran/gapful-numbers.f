! Gapful numbers
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program GapFul
implicit none

!Show the first 30 gapful numbers
call printGapful (start=100, count=30)    ! ignoring 0...99
write (*,*)

!Show the first 15 gapful numbers ≥ 1,000,000
call printGapful (start=1000000, count=15)
write (*,*)

!Show the first 10 gapful numbers ≥ 1,000,000,000
call printGapful (start=1000000000, count=10)


contains

! ========================================================================
! Calculate and print 'count' Gapful Numbers, starting at value of 'start'
! ========================================================================

subroutine printGapful (start, count)
integer, intent(in) :: start, count

integer :: num, cnt
num = start
cnt = 0
write (*, '("First ", i0, " gapful numbers from ", i0)') count, start
do
  if (isGapful (num)) then
    cnt = cnt + 1
    if (cnt .lt. count) then
      write (*,'(I0, ", ")', advance='no')    num
      ! Write Line break if line is getting too long, because VMS doesn't like it.
      if (mod (cnt,10) .eq. 0) write (*, '(/)', advance='no')
    else
      write (*, '(I0)') num
      Exit
    end if
  end if
  num = num + 1
enddo

end subroutine printGapful

! ================================================================
! Return true if 'n' is a gapful number as defined in Description
! ================================================================

logical function isGapful (n)
integer, intent(in) :: n

integer :: nn, firstdigit, lastdigit, divisor
nn = n
lastdigit = mod (nn, 10)
nn = nn / 10

! divide by ten until only 1 digit left. That digit is the first digit.
do
  nn = nn / 10
  if (nn .lt. 10) then    ! only 1 digit left
    firstdigit = nn       ! Remember as first digit
    exit                  ! quit looping
  endif
end do

divisor = 10*firstdigit + lastdigit
isGapful =  (mod (n, divisor) .eq. 0)
end function isGapful

end program GapFul
