! Move-to-front algorithm
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., February 2026
!=========================================================================================
program FrontMove
implicit none

! Starting sequence in the local symbol tables in 2 subroutines
character (len=26), parameter :: startSymbolTab = 'abcdefghijklmnopqrstuvwxyz'

! The test cases of the task description:
call EncodeAndCrossCheck ('broood')
call EncodeAndCrossCheck ('bananaaa')
call EncodeAndCrossCheck ('hiphophiphop')

! Two more tests: What happens in MoveToFront() if char appears at the beginning ('a')
! or at the end ('z') of the symbol table?
call EncodeAndCrossCheck ('anton')
call EncodeAndCrossCheck ('zwareshagz')

contains

! =========================================================================
! Encode a given text string using the Move-to-fromt algorithm, then
! decode the resultant sequence of numbers, to be compared to the original.
! =========================================================================
subroutine EncodeAndCrossCheck (text)

character (len=*), intent(in) :: text         ! Input: the text to encode

integer, dimension(len(text)) :: code         ! Resultant numeric array

character (len=26) :: SymTab                  ! The symbol table to work with
integer :: l                                  ! LEngth of input text
integer :: ii, idx                            ! Loop index, Pos of a char inside Symbol Table

! Initialize work table
SymTab = startSymbolTab
l  = len (text)

write (*,'(A, T13, A)', advance='no')   text, ' ->'
! Encoding Algorithm:
!    for each symbol of the input sequence:
!        output the index of the symbol in the symbol table
!        move that symbol to the front of the symbol table

do ii=1, l
  idx = index (SymTab, text(ii:ii))
  code (ii) = idx-1                           ! Code muss be null-based
  write (*, '(I3)', advance='no')    code(ii)
  call moveToFront (SymTab, idx)
end do
do ii=3*l,36
  write (*,'(x)', advance='no')                              ! some space to format output
enddo
write (*,'(A)', advance='no')    ' -> '
! Now decode the resultant code and hope to see again the original text.
call decodeAndCheck (code, l, text)

end subroutine EncodeAndCrossCheck


! =====================================================================================
! Decode a given array of numbers and check if the rtesult matches the given input text
! =====================================================================================
subroutine decodeAndCheck (code, l, text)

integer , intent(in) ::l
integer, dimension(l), intent(in) :: code
character (len=*), intent(in) :: text         ! the text to compare to the decode result.

character (len=26) :: SymTab
integer :: ii, idx
logical :: mismatch

! # Using the same starting symbol table
SymTab = startSymbolTab
mismatch = .false.

! Decoding Algorithm:
!    for each index of the input sequence:
!        output the symbol at that index of the symbol table
!        move that symbol to the front of the symbol table
do ii=1, l
  idx = code(ii) + 1
  write (*, '(A1)', advance='no')    SymTab (idx:idx)
  if (SymTab (idx:idx) .ne. text (ii:ii)) mismatch = .true.
  call moveToFront (SymTab, idx)
end do

if (.not. mismatch) then
  write (*,*) '(Success)'
else
  write (*,*) 'ERROR.'
endif

end subroutine decodeAndCheck


! =========================================================================
! Move the character found at index 'ind' in the string "'txt' to the front
! =========================================================================
subroutine moveToFront (txt, ind)
character (len=*), intent(inout) :: txt
integer, intent(in) :: ind

! Rearrange txt: character at ind, then everything in front of ind, then everything behind.
txt = txt(ind:ind) // txt(:ind-1) // txt (ind+1:)
end subroutine moveToFront

end program FrontMove
