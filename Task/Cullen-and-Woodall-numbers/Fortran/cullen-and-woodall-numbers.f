!
! Cullen and Woodall numbers
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
!

program CullenWoodall

  implicit none

  integer :: power

  integer ::ii, Cullen
  integer, parameter :: nNum=20

  power = 1
  write (6, '("  n     Cullen   Woodall")')
  write (6, '("  ----------------------")')
  do ii=1, nNum
    power  = power * 2
    cullen = ii * power + 1
    write (6, '(x, i2, ": ", I9, x, i9 )' ) ii,  cullen, cullen-2
  end do


end program CullenWoodall
