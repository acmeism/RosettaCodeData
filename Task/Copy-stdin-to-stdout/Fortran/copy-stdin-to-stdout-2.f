! Copy stdin to stdout
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!
! can also be compiled with gfortran but fails at run-time because it cannot change the access parameter
! -------------------------------------------------------------------------------------------------------
!
program cp
character :: c
integer:: ios

open (unit=5, form='unformatted', access='stream', action ='read')
open (unit=6, form='unformatted', access='stream', action ='write')

do
  read (5, iostat=ios) c
  if (ios .ne. 0) exit
  write (6) c
end do

end program cp
