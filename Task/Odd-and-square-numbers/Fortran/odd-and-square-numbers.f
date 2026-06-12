! Odd Square Numbers
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program OddSquareNumbers
!
implicit none

integer :: n, n2

! square Number n2=n*n > 99: n >= 10
! Only squared odd numbers can result in odd square numbers
! Start with 11, which is the smallest odd number >=10
!
n = 11
n2 = n*n

do while (n2 .lt. 1000)
  write (*, '(I0)', advance='no')  n2
  n = n + 2
  n2 = n*n
  if (n2 .lt. 1000) write (*, '(", ")', advance='no') ! Separator only if not the last printout
enddo
write (*,*)                                           ! Terminate output line
end program OddSquareNumbers
