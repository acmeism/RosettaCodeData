!
! Dating Agency
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program DatingAgency
implicit none
!
! The names have trailing spaces because gfortran does not accept
! different lengths in array of constant strings
!
character (len=7), dimension(10), parameter :: sailors = &
  ['Adrian ', 'Caspian', 'Dune   ', 'Finn   ', 'Fisher ', 'Heron  ', 'Kai    ', &
   'Ray    ', 'Sailor ', 'Tao    ']
character (len=8), dimension(10), parameter :: ladies = &
  ['Ariel   ', 'Bertha  ', 'Blue    ', 'Cali    ', 'Catalina', 'Gale    ', 'Hannah  ', &
   'Isla    ', 'Marina  ', 'Shelly  ']
integer :: ilady, isailor

do ilady=1, size(ladies)
  if (loves_a_sailor (ladies(ilady))) then
    write (*,'("Dating service should offer a date with ", A)') &
      ladies(ilady)(:len_trim(ladies(ilady)))
    do isailor = 1, size(sailors)
      if (loves_a_lady (ladies(ilady), sailors(isailor))) then
        write (*,'("    Sailor ", A, " should take an offer to date her" )') &
          sailors(isailor)(:len_trim(sailors(isailor)))
      endif
    end do
  else
    write (*,'("Dating service should NOT offer a date with ", A)') &
      ladies(ilady)(:len_trim(ladies(ilady)))
  endif
end do



contains


function loves_a_sailor (lady)  result (SheDoes)
character(len=*), intent(in) :: lady
logical :: sheDoes

sheDoes =  mod (ichar(lady(1:1)), 2) .eq. 0
end function loves_a_sailor

function loves_a_lady (lady, sailor) result (HeDoes)
character(len=*), intent(in) :: lady, sailor
logical :: HeDoes

HeDoes = mod (ichar(lady(len_trim(lady):len_trim(lady))), 2) .eq.         &
         mod (ichar(sailor(len_trim(sailor):len_trim(sailor))), 2)
end function loves_a_lady


end program DatingAgency
