!
! Multisplit
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program Multisplit
implicit none

character (len=*), parameter :: inputString = 'a!===b=!=c'
integer, parameter ::nSep=3

character (len=2), dimension(nSep), parameter ::  separators =  ['==', '!=', '= ']
! Trailing spaces in the separator strings will be ignored
! The order in which the separators are defined here is significant because
! '=' conflicts with '==' if '=' comes before '=='.

call split (inputString, separators, nSep)

contains


! ========================================================================
! Split input string "txt", at positions of any of the separators "sep)
! print recognised separators in parentheses(), and also the ordinary text
! ========================================================================
subroutine split (txt, separators, nSep)
character (len=*), intent(in) :: txt
integer, intent(in) :: nSep
character (len=*), dimension(nSep) :: separators

integer :: ii, idx

write (*, '("Input:  ", A)')   txt
write (*, '("Result: ")', advance='no')

ii = 1
do while (ii .le. len_trim(txt))                                      ! step through the entire input string, letter by letter
  idx = match (txt, ii, separators, nSep)                             ! Try to find one of the separators at position ii
  if (idx .eq. 0) then                                                ! If we find no separator at position ii ...
    write (*, '(A1)', advance='no') txt(ii:ii)                        ! ... print letter at pos. ii,
    ii = ii + 1                                                       ! ... and go to next letter
  else                                                                ! If Separator # idx found here,...
    write (*, '("(",A,")")', advance='no') separators(idx)(:len_trim(separators(idx)) )    ! ... print the separator in (),
    ii = ii + len_trim(separators(idx))                               ! ... and skip to next letter
  endif
end do
write (*,*)                                                           ! Terminate output line.
end subroutine split

! ==============================================================
! Check if txt at position istart matches any of the separators.
! If so, return index of the matching separator, otherwise 0.
! ==============================================================
function match (txt, istart, separators, nsep ) result (ix)

character (len=*), intent(in) :: txt
integer, intent(in) :: nsep, istart
character (len=*), dimension(nsep), intent(in) :: separators
integer :: ix
integer :: ii

do ii=1, nsep
  if (txt(istart:istart-1+len_trim(separators(ii))) .eq. separators(ii)(:len_trim(separators(ii)))) then
    ix = ii
    return
  endif
enddo
ix = 0      ! no match
end function match
end program Multisplit
