!
!Check input device is a terminal
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!
! This is completely non-standard. It relies on the function isatty(lun)
! which is documented as compiler-specific extension to both ifx and Gnu gfortran.
!
! U.B., January 2026
!==============================================================================
program checkTTY

implicit none

integer :: unit
logical :: isatty

! expect units 5 (standard input)  and 6 (standard output) to be terminals,
! unless it redirected to a file
! ./checktty will write that units 5 and 6 are Terminals,
! ./checktty <a.out will give 5 is not a terminal but 6 is
! ./checktty >b.out will write to b.out, and this contains unit 5 is a terminal but unit 6 ism't
! ./checktty < a.out >b.out will write to b.out, and both units 5 and 6 are not terminals.
!
! Check units 1...10 if they are connected to a terminal.
do unit=1,10
  if (isatty (unit)) then
    write (*, '("Unit ", i2, " is a Terminal")') unit
  else
    write (*, '("Unit ", i2, " is NOT a Terminal")') unit
  endif
enddo

end program checkTTY
