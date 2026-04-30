!
! Bioinformatics/Sequence mutation
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program BioInfo

implicit none

integer, parameter :: IniLen = 200                    ! Initial length of the DNA sequence
integer, parameter :: nMutations = 10                 ! Number of Mutations to apply
integer, parameter :: MaxLen = IniLen + nMutations    ! Each mutation could be an insertion

character (len=MaxLen) :: DNASequence                 ! The DNA Sequence to work with

character ,dimension(4), parameter :: Bases = ['A','C','G','T']   ! Thew 4 bases in the sequence
integer, dimension(4) :: hist                                     ! COunters of bases
character :: newBase                                              ! character for Replacement/Insertion mutation
integer :: ii, posMut                                             ! Loop index, position of mutation

call random_seed()                                     ! Initialize random generator

! Fill the sequence
do ii=1, IniLen
  DNASequence (ii:ii) = Bases(randominInterval (1, 4))
end do
DNASequence (iniLen+1:) = ' '                           ! THe rest is blank

! Print it
call prettyPrint (DNASequence, 100, "Sequence:")

! Apply the mutations
write (*, '(/,i0, X, "Mutations:")')  nMutations
do ii=1, nMutations
  posMut = randominInterval (1, iniLen)                 ! Where to mutate...
  select case (randominInterval (1,3))                  ! ... and how
  case (1)
  ! Swap
    newBase = Bases(randominInterval (1, 4))
    write (*,'(A10, x, A1, " at ", I0, " with ", A1 )')  'Substitute', DNASequence (posMut:posMut), posMut, newBase
    DNASequence (posMut:posMut) = newBase
  case (2)
  ! Delete
    write (*,'(A10, x, A1, " at ", I0)')  'Delete', DNASequence (posMut:posMut), posMut
    DNASequence  = DNASequence (1:posMut-1) // DNASequence (posMut+1:maxLen)
  case (3)
  ! Insert before
    newBase = Bases(randominInterval (1, 4))
    write (*,'(A10, x, A1, " before ", A1 , " at ", I0)')  'Insert', newBase, DNASequence(posMut:posMut), posMut
    DNASequence  = DNASequence (1:posMut-1) // newBase // DNASequence (posMut:maxLen)
  end select
enddo

! Print result
call prettyPrint (DNASequence, 100, "Sequence after the mutations:")

contains

! ============================================================
! Print one line of explanatory text, then the DNA Sequence rs
! (max. iLine in a line), and the Base Counts
! =============================================================
subroutine prettyPrint (rs, lLine, Explanation)
integer, intent(in) :: lLine
character (len=*), intent(in) ::rs, Explanation
integer :: ii, idx, l
l = len_trim(rs)

write (*,'(/A)') Explanation
do ii=1, l, lLine
  write (*, '(i3,": ", A)') ii, rs(ii:min(l,ii+lLine-1))
end do

hist = 0
do ii=1, len_trim(rs)
  do idx = 1, 4
    if (rs(ii:ii) .eq. Bases (idx)) then
      hist (idx) = hist(idx) + 1
      exit
    end if
  end do
end do

write (*, '(/,"Base Count:")')
do ii=1,4
  write (*,'(A5, ": ", i3)')    Bases (ii), hist (ii)
end do
write (*, '("Total: ", i3)') l
end subroutine prettyPrint


! ===========================================================
! Generate random number between @lo and @hi (inclusive)
! Assume Random Number Generator has been initialized before.
! ===========================================================
function randominInterval (lo, hi) result (r)
integer, intent(in) :: lo, hi                         ! the interval
integer :: r                                          ! resultant (pseudo-)random number
real :: rnd                                           ! Fortran random number generator generates float values
call random_number (rnd)                              ! 0. <= rnd < 1.
r = lo + FLOOR((hi+1-lo)*rnd)                         ! We want to choose one between [lo,hi]: add +1 to possibly include "hi".
end function randominInterval



end program BioInfo
