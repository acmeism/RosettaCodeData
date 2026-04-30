! Copy stdin to stdout
! tested with GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             uses non-standard function fget and gput, both are available in gfortran only.
! ------------------------------------------------------------------------------------------
!
program cp

implicit none

character :: c                              ! The chcaracter to read
integer :: ios                              ! IO Status


do
  ios = fget (c)          ! gfortran only
  if (ios .ne. 0) exit
  call fput(c)            ! gfortran only
end do

end program cp
