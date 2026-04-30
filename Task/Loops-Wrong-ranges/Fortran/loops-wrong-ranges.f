! Loops/Wrong ranges
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU gfortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0 on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
!

program wrongLoops

implicit none

call testLoop (-2, 2, 1, "Normal")
call testLoop (-2, 2, 0, "Zero increment")
call testLoop (-2, 2, -1, "Increments away from stop value")
call testLoop (-2, 2, 10, "First increment is beyond stop value")
call testLoop (2, -2, 1, "Start more than stop: positive increment")
call testLoop (2, 2, 1, "Start equal stop: positive increment")
call testLoop (2, 2, -1, "Start equal stop: negative increment")
call testLoop (2, 2, 0, "Start equal stop: zero increment")
call testLoop (0, 0, 0, "Start equal stop equal zero: zero increment")

contains

subroutine testLoop (lower, upper, step, text)
integer, intent(in) :: lower, upper, step
character (len=*), intent(in) :: text
integer :: cnt, ii

write (*,'(1x, A, T45, "(", 2(i0,", "),i0, ")",t56," -> " )', advance='no')  text, lower, upper, step

cnt = 0

! From the IFX documentation: The iteration count is calculated as follows:
!       MAX(INT((expr2 - expr1 + expr3)/expr3), 0)
! So if exp3 (here: step) is 0, a division by 0 occurs, resulting in a run-time error.
!
if   (step .ne. 0) then                           ! Avoids run-time error
  write (*,'("[")', advance='no')
  do ii = lower, upper, step
    if (step .gt. 0 .and. ii .le. upper-step .or. step .lt. 0 .and. upper+step .gt. lower) then
      ! Not at last iteration: print ii followed by comma
      write (*, '(i0, ", " )', advance='no')   ii
    else
      ! Last iteration: no comma following printout of ii.
      write (*, '(i0)', advance='no')   ii
    endif
    cnt = cnt + 1
    if (cnt .ge. 10) exit
  end do
  write (*,'("]")')
else
  write (*,'("Error: Increment must not be zero")')
endif
end subroutine testLoop

end program wrongLoops
