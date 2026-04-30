! Minimum multiple of m where digital sum equals m
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program minimumMultiple

integer :: n, m
do n=1, 70                                ! going to find 70 elements of the sequence
  m = 1
  do while (digitSum (m*n) .ne. n)        ! Brute force: increment m until digit sum of m*n equals n
    m = m + 1
  enddo
  write (*,'(I10)', advance='no') m       ! Print result
  if   (mod(n, 10) .eq. 0)   write (*,*)  ! limit of 10 numbers per line
enddo

contains

! calculate digitsum of argument n
function digitSum (n) result (r)
integer, intent(in) :: n
integer :: r
integer:: wn                              ! copy of n to work with

wn = N
r=0
do while (wn .ne. 0)
  r = r + mod(wn,10)                      ! Add last digit
  wn = wn / 10                            ! eliminate last digit
enddo                                     ! Repeat this until no more digits

end function digitSum
end program minimumMultiple
