! Exponentiation with infix operators in (or operating on) the base
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., February 2026
!=========================================================================================
program Expo
implicit none
integer:: x, p

write (*,'(2x,a,2x,a,2x,a,2x,a,2x,a,2x,a,2x,a)')  'x', 'p',  '-x**p', '-(x)**p', '(-x)**p', '-(x**p)'
do x=-5,5,10
  do p=2, 3
    write (*, '(i3, i3, 2 (i7), 2x, 2 (i7,x))')  x, p, -x**p, -(x)**p, (-x)**p, -(x**p)
  end do
end do

end program Expo
