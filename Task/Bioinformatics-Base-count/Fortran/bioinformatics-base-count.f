! Bioinformatics/Base count
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., February 2026
!=========================================================================================
program BaseCount

implicit none

character (len=*), parameter :: rawString =  &
          'CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG'    &
    //    'CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG'    &
    //    'AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT'    &
    //    'GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT'    &
    //    'CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG'    &
    //    'TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA'    &
    //    'TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT'    &
    //    'CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG'    &
    //    'TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC'    &
    //    'GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT'
integer, parameter :: lineLength = 50

call prettyPrint (rawString, lineLength)
call calcPrintStatistics (rawString)


contains

!=================================================================
! Count all 4 bases separately and print the resultant statistics.
!=================================================================
subroutine calcPrintStatistics (rs)

character (len=*), intent(in) ::rs                  ! The DNA sequence
integer, parameter :: nBase = 4                     ! Number of bases
character (len=nBase), parameter :: Bases = 'ACGT'  ! the letters indicating the bases

integer ::rsLen                                     ! Length of the input string
integer :: baseCount (nBase)                        ! counters for the bases
integer :: ii, baseNo                               ! Loop index, Base Index

! Initialize local variables
rsLen = len_trim (rs)
baseCount = 0

! collect statistics
do ii=1, rsLen
  baseNo = index (Bases, rs(ii:ii))                 ! would be 0 for letters other than A,C,G,T
  if (baseNo .gt.0 .and. baseNo .le. nBase) then
    baseCount (baseNo) = baseCount(baseNo) + 1
  end if
end do

! Print result
write (*,'(/1x,A,i0,A)') 'Base Counts (total=', sum(baseCount),'):'
do ii=1,nBase
  write (*, '(3x,A,": ", i3)')   Bases(ii:ii), baseCount(ii)
end do

! Just to be sure: compare string length with counted number of expected, correct bases:
if (rsLen .ne. sum(baseCount) ) then
  write (*,'(/,1x,A,X,A)')   'Attention: DNA sequence contains characters other than', Bases
end if

end subroutine calcPrintStatistics

subroutine prettyPrint (rs, lLine)
integer, intent(in) :: lLine
character (len=*), intent(in) ::rs

integer :: ii
write (*,'(/1x,A)') 'Sequence:'
do ii=1, len_trim(rs), lLine
  write (6, '(1x,i3,": ", A)') ii, rs(ii:min(len_trim(rs),ii+lLine-1))
end do


end subroutine prettyPrint

end program BaseCount

