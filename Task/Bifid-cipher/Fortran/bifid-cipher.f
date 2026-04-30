!
! Bifid cipher
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
!
! U.B., October 2025
!==============================================================================

program BifidCipher

implicit none

! Constants:

integer, parameter :: nTests = 6          ! NUmber of different test messages
integer, parameter :: maxLen=100          ! Maximum length of any test message

! Instead of drawing the Polybius squares, we only define the alphabet to applied and calculate
! row and column number on the fly when needed.
! If necessary, the Encrypt and Decrypt subroutines extend the alphabets using "SpareAlpha"
! until the total length of the extended alphabet is a square number. This is important because
! otherwise the enccrypt or decrypt algorithm may calculate a row/column combination that is
! not used by the actual alphabet.

! The alphabet as shown in the task description has no J.
character (len=*), parameter :: Alphabet_no_J ='ABCDEFGHIKLMNOPQRSTUVWXYZ'

! The alphabet of capital letters as used in most western languages
character (len=*), parameter :: Alphabet_With_J ='ABCDEFGHIJKLMNOPQRSTUVWXYZ'

! The square in the wikipedia article in 1 long string:
character (len=*), parameter :: AlternateAlphabet = 'BGWKZQPNDSIOAXEFCLUMTHYVR'

! Standard Alphabet with CAPITAL and small letters
character (len=*), parameter :: Alphabet_withSmallLetters =  &
                       'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

! Printable spare characters to extend alphabets so the total length becomes the
! next larger square number > the alphabet's length
character (len=*), parameter :: SpareAlpha = '1234567890!"§$%&/()=' ! omitted ! and "

! Variables:

character (len=maxLen) :: MsgToEncrypt (nTests), EncryptedMsg (nTests), DecryptedMsg (nTests)

integer :: ColWidth     ! Is variable and depends on length of the used alphabet

integer :: i, lx

! The test strings: (1) is from the task description, (2) is from the  Wikipedia Article, (3) is
! the additional message as presented in the task description
MsgToEncrypt(1) = 'ATTACKATDAWN'
MsgToEncrypt(2) = 'FLEEATONCE'
MsgToEncrypt(3) = 'THEINVASIONWILLSTARTONTHEFIRSTOFJANUARY'

! Same text, with both small and capital letters, to be used with an extended Polybius square
MsgToEncrypt(4) = 'AttackAtDawn'
MsgToEncrypt(5) = 'FleeAtOnce'
MsgToEncrypt(6) = 'TheInvasionWillStartOnTheFirstOfJanuary'

print '(A/)', 'Using the alphabet and Polybius square without "J"'
call PrintSquare (Alphabet_no_J)
do i=1, nTests/2
  lx = len_trim (MsgToEncrypt(i))
  call encrypt (MsgToEncrypt(i)(:lx) , EncryptedMsg (i) , Alphabet_no_J)
  call decrypt (EncryptedMsg(i) (:lx), DecryptedMsg (i) , Alphabet_no_J)
  print '(A, " => ", A, " => ", A)', MsgToEncrypt(i)(:lx), EncryptedMsg (i)(:lx), DecryptedMsg (i)(:lx)
enddo

print '(/A/)', 'Using the extended alphabet and Polybius square that includes "J"'
call PrintSquare (Alphabet_with_J)
do i=1, nTests/2
  lx = len_trim (MsgToEncrypt(i))
  call encrypt (MsgToEncrypt(i)(:lx) , EncryptedMsg (i) , Alphabet_with_J)
  call decrypt (EncryptedMsg(i) (:lx), DecryptedMsg (i) , Alphabet_with_J)
  print '(A, " => ", A, " => ", A)', MsgToEncrypt(i)(:lx), EncryptedMsg (i)(:lx), DecryptedMsg (i)(:lx)
end do

print '(/A/)', 'Using the alphabet and Polybius square as shown in the Wikipedia article (no J!)'
call PrintSquare (AlternateAlphabet)
do i=1, nTests/2
  lx = len_trim (MsgToEncrypt(i))
  call encrypt (MsgToEncrypt(i)(:lx) , EncryptedMsg (i) , AlternateAlphabet)
  call decrypt (EncryptedMsg(i) (:lx), DecryptedMsg (i) , AlternateAlphabet)
  print '(A, " => ", A, " => ", A)', MsgToEncrypt(i)(:lx), EncryptedMsg (i)(:lx), DecryptedMsg (i)(:lx)
end do

print '(/A/)', 'Using the extended alphabet with both upper case and lower case letters, including J and j'
call PrintSquare (Alphabet_withSmallLetters)
do i=nTests/2+1, nTests
  lx = len_trim (MsgToEncrypt(i))
  call encrypt (MsgToEncrypt(i)(:lx) , EncryptedMsg (i) , Alphabet_withSmallLetters)
  call decrypt (EncryptedMsg(i) (:lx), DecryptedMsg (i) , Alphabet_withSmallLetters)
  print '(A, " => ", A, " => ", A)', MsgToEncrypt(i)(:lx), EncryptedMsg (i)(:lx), DecryptedMsg (i)(:lx)
end do

contains

!======================
! Encode a given string
! ======================
subroutine encrypt (inString,outString, argAlphabet)
character (len=*), intent(in)  :: argAlphabet
character (len=*), intent(in)  :: inString
character (len=*), intent(out) :: outString
character (len=100) :: Alphabet

integer :: idxLine(2*maxLen)
integer :: l, ii, idx, row, col

! Calculate required column width: so that ColWidth^2 >= (length of Alphabet)
Alphabet = argAlphabet
l = len_trim(alphabet)
ColWidth = 1
do while (ColWidth*ColWidth .lt. l)
  ColWidth = ColWidth + 1
end do
if (ColWidth .gt.8) stop 'ERROR: Cannot handle Alphabets with more than 64 characters.'
! Provide some printable chars until the length is a square number
Alphabet (l+1:) = SpareAlpha

l = len_trim (inString)
if (l .gt. len(outString))   stop 'ERROR: not enough storage space for encrypt result string.'

do ii=1, l
!  print *, '  ii = ', ii, ' instring(ii) = ', inString(ii:ii)
  idx = index (Alphabet, inString(ii:ii))
  if (idx .eq. 0) idx = index (Alphabet, char(ichar(instring(ii:ii))-1)) ! J=I, j=i, just in case
  row = (idx+ColWidth-1) / ColWidth         ! e.g. 'A' ...'E', idx=1...5, row=(5...9)/5 = 1, col = 1...5
  col =  1+mod (idx+ColWidth-1, ColWidth)    ! e.g. 'F' ...'K', idx=6...10, row=(10...14)/5 = 2, col = 1...5
  idxLine (ii) = row
  idxLine (ii+l) = col
end do

do ii=1, l
  idx = 10*idxLine(1+2*(ii-1)) + idxLine (2+2*(ii-1))
  row = idxLine(1+2*(ii-1))
  col = idxLine (2+2*(ii-1))
  idx = ColWidth*(row-1) + col
  outString (ii:ii) = alphabet (idx:idx)
enddo
end subroutine encrypt


!======================
! Decode a given string
!======================
subroutine decrypt (inString,outString, argAlphabet)

character (len=*), intent(in)  :: inString
character (len=*), intent(out) :: outString
character (len=*), intent(in)  :: argAlphabet

character (len=100) :: Alphabet

integer :: idxLine(2*maxLen)
integer :: l, ii, idx, row, col

! Calculate required column width: so that ColWidth^2 >= (length of Alphabet)
Alphabet = argAlphabet
l = len_trim(alphabet)
ColWidth = 1
do while (ColWidth*ColWidth .lt. l)
  ColWidth = ColWidth + 1
end do

! Append some spare characters so that the square is completely filled without undefined fields
Alphabet (l+1:) = SpareAlpha

l = len_trim (inString)
if (l .gt. len(outString))   stop 'ERROR: not enough storage space for decrypt result string.'

do ii=1, l
  idx = index (Alphabet, inString(ii:ii))
  row = (idx+ColWidth-1) / ColWidth          ! idx 1...5 is row 1, 6...10 is row 2 etc
  col = 1+mod (idx+ColWidth-1, ColWidth)         ! so that 21...29 -> 1...9 etc.
  idxLine (1+2*(ii-1)) = row
  idxLine (2+2*(ii-1)) = col
end do

do ii=1, l
  row = idxLine (ii)
  col = idxLine (ii+l)
  idx = ColWidth*(row-1) + col
  outString (ii:ii) = alphabet (idx:idx)
end do

end subroutine decrypt


! ================================================================================
! Print the resulting Polybius square based on the alphabet used for encode/decode
! ================================================================================
subroutine PrintSquare (Alphabet)
character (len=*), intent(in)  :: Alphabet
integer:: ii, l

l = len_trim(alphabet)
ColWidth = 1
do while (ColWidth*ColWidth .lt. l)
  ColWidth = ColWidth + 1
end do
print '("The alphabet has a length of ", I0, " so it requires the square size of ", I0, "x", I0 /)' , l, ColWidth, ColWidth

do ii=1, ColWidth*ColWidth
  if (ii .le. l) then
    write (*, '(A2)', advance='no')  Alphabet(ii:ii)
  else
    write (*, '(A2)', advance='no')  SpareAlpha (ii-l:ii-l)   ! Use spares to complete the square
  endif
  if (mod (ii, ColWidth) .eq. 0) print *                      ! End of line
end do
print *                                                       ! one extra blank line
end subroutine PrintSquare


end program BifidCipher
