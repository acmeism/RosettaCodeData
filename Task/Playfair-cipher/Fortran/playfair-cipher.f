!
! Playfer Cipher
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
!
! U.B., October 2025
!==============================================================================

program PlayferCipher

  implicit none

  integer, parameter :: nTests = 2          ! Number of different test messages
  integer, parameter :: maxLen=100          ! Maximum length of any test message (including extensions as 'X')

  ! The complete alphabet of capital letters as used in most western languages
  character (len=*), parameter :: Alphabet ='ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  character (len=maxLen) :: MsgToEncrypt (nTests), EncryptedMsg, DecryptedMsg
  logical                :: Omit_Q       ! True: omit Q in alphabet, False: use I for both I and J
  character (len=25)     :: PassPhrase(nTests)

  integer, parameter :: ColWidth =5     ! depends on length of the used alphabet but we use only 25 letters

  integer :: i

  ! The message to encrypt - for 1 test case
  ! the additional message as presented in the task description
  MsgToEncrypt(1) = 'Hide the gold ... in the tree stump!!!'
  PassPhrase(1) = 'playfair example'

  MsgToEncrypt(2) = 'This is another simple test message.'
  PassPhrase(2) = 'This is top secret'

  do i=1, nTests
    Omit_Q = (i .ne. 1)                     ! to see both variants: dont use Q or convert J to I
    call encode      (MsgToEncrypt(i) , EncryptedMsg, Alphabet, Omit_Q, PassPhrase(i))
    call decode      (EncryptedMsg, DecryptedMsg, Alphabet, Omit_Q, PassPhrase(i))
    call printResult (MsgToEncrypt(i), EncryptedMsg, DecryptedMsg)
  enddo


contains

! =======================================================================
! 2 Jacket routines for encode and decode - they end up in the same crypt
! routine with an additional argument for the direction
! =======================================================================
subroutine encode (argInString, outString, argAlphabet, argOmit_Q, argPassPhrase)
  character (len=*), intent(in)  :: argInString
  character (len=*), intent(out) :: outString
  character (len=*), intent(in)  :: argAlphabet
  logical, intent(in) :: argOmit_Q
  character (len=*), intent(in) :: argPassPhrase

  call crypt (argInString, outString, argAlphabet, argOmit_Q, argPassPhrase, 1)

end subroutine encode

subroutine decode (argInString, outString, argAlphabet, argOmit_Q, argPassPhrase)
  character (len=*), intent(in)  :: argInString
  character (len=*), intent(out) :: outString
  character (len=*), intent(in)  :: argAlphabet
  logical, intent(in) :: argOmit_Q
  character (len=*), intent(in) :: argPassPhrase

  call crypt (argInString, outString, argAlphabet, argOmit_Q, argPassPhrase, -1)

end subroutine decode


!=========================================================================
! Encode or decode a given string. Direction is 1 to encode, -1 to decode.
! ========================================================================
subroutine crypt (argInString, outString, argAlphabet, argOmit_Q, argPassPhrase, direction)

  character (len=*), intent(in)  :: argInString
  character (len=*), intent(out) :: outString
  character (len=*), intent(in)  :: argAlphabet
  logical, intent(in) :: argOmit_Q
  character (len=*), intent(in) :: argPassPhrase
  integer , intent(in) :: direction

  character (len=100) :: LocalAlphabet
  character (len=MaxLen)   :: inString

  integer :: idxLine(2*maxLen)
  integer :: l, ii, idx, jdx, row, col

  inString = argInString                                            ! have a mutable copy or intent(in) argument
  outString = ' '

  call changeAllToUpcase (inString)

  call setupAlphabet (argAlphabet, LocalAlphabet, argOmit_Q, argPassPhrase)
  if   (direction .eq. 1)   call PrintSquare (LocalAlphabet)        ! when encoding, show the Polybius square
  if (.not. argOmit_Q) then
    call FixJ_I (inString)                                          ! Replace all J by I.
  endif

  l = len_trim (inString)
  if (l .gt. len(outString))   stop 'ERROR: not enough storage space for encrypt result string.'

  ! En/Decode every group of two characters
  idx = 1
  jdx = 1
  do while (idx .le. l)
    if (idx .lt. l) then
      if (inString (idx:idx) .ne. inString (idx+1:idx+1)) then
        outString(jdx:jdx+1) = decode2Group (inString (idx:idx),inString (idx+1:idx+1), LocalAlphabet, direction)
        idx = idx + 2
        jdx = jdx+2
      else
        outString(jdx:jdx+1) = decode2Group (inString (idx:idx), 'X', LocalAlphabet, direction)
        idx = idx + 1
        jdx = jdx+2
      endif
    else if (idx .eq. l) then
      outString(jdx:jdx+1) = decode2Group (inString (idx:idx), 'X', LocalAlphabet, direction)
      idx = idx + 1
      jdx = jdx+2
    end if
  end do

end subroutine crypt

! =======================================
! Modify input string, replace all J by I
! =======================================
subroutine FixJ_I (inString)
  character (len=*), intent(inout)  :: inString
  integer :: l, ii
  l = len_trim (inString)
  do ii=1,l
    if (inString (ii:ii) .eq. 'J') inString (ii:ii) = 'I'
  enddo
end subroutine FixJ_I

! ================================================================================
! Encode or Decode a group of 2 letters according to the rules for Playfair Cipher
! ================================================================================
function decode2Group (ch1, ch2, argAlphabet, direction)  result (res)
  character, intent(in) :: ch1, ch2                         ! 2 characters to decode
  character (len=*), intent(in)  :: argAlphabet             ! Argument to use for encoding
  integer, intent(in) :: direction                          ! 1 for encode, -1 for decode
  character (len=2)  ::  res                                ! resultant group of 2 chars

  integer :: r1,r2,c1,c2                                    ! row, col of ch1 and ch2
  integer :: idx

  call getRC (ch1,r1,c1,argAlphabet)
  call getRC (ch2,r2,c2,argAlphabet)

  if (r1 .ne. r2 .and. c1 .ne. c2) then                     ! c1 and c2 form a rectangle
    res(1:1) = getChar (r1,c2,argAlphabet)                  ! Same rows, opposite corner
    res(2:2) = getChar (r2,c1,argAlphabet)
  else if (r1 .eq. r2 .and. c1 .ne. c2) then                ! c1 and c2 in horizontal line
    ! pick item to right (left) of each, wrap if required
    c1 = c1 + direction                                     ! Easier to read...
    if (c1 .gt. ColWidth) c1 = 1                            ! than a fancy formula...
    if (c1 .lt. 1) c1 = ColWidth                            ! with modulus and offset
    c2 = c2 + direction
    if (c2 .gt. ColWidth) c2 = 1
    if (c2 .lt. 1) c2 = ColWidth
    res(1:1)=getChar (r1,c1,argAlphabet)
    res(2:2)=getChar (r2,c2,argAlphabet)
  else if (c1 .eq. c2 .and. r1 .ne. r2) then                ! c1 and c2 in vertical line
    ! pick item to below (above) each, wrap if required
    r1 = r1 + direction
    r2 = r2 + direction
    if (r1 .gt. ColWidth) r1 = 1
    if (r1 .lt. 1) r1 = ColWidth
    if (r2 .gt. ColWidth) r2 = 1
    if (r2 .lt. 1) r2 = ColWidth
    res(1:1) = getChar (r1,c1,argAlphabet)
    res(2:2) = getChar (r2,c1,argAlphabet)
  else
    ! should be impossible: c1 .eq. c2
    stop 'duplicate letter in group of 2 letters: BUG CHECK'
  endif
end function decode2Group

! ======================================================
! Get Row and Column  of a letter in the Polybius square
! ======================================================
subroutine getRC (c,row,col, argAlphabet)
  character, intent(in) :: c
  integer, intent(out) :: row,col
  character (len=*), intent(in)  :: argAlphabet             ! Argument to use for encoding
  integer :: idx

  idx = index (argAlphabet, c) - 1

  row = 1 + idx / ColWidth
  col = 1 + mod (idx, ColWidth)

end subroutine getRC

! ==================================================
! Return letter in row column of the Polybius square
! ==================================================
function getChar (row,column,argAlphabet) result (chr)
  integer, intent(in) :: row, column
  character (len=*), intent(in)  :: argAlphabet             ! Argument to use for encoding
  character :: chr
  integer :: idx

  idx = (row-1) * ColWidth + column
  chr = argAlphabet (idx:idx)

end function getChar


! ===============================================================================
! Modify string: convert lower case to upper case, skip whitespace or punctuation
! ===============================================================================
subroutine changeAllToUpcase (str)
  character (len=*), intent(inout) :: str
  integer :: ii, jj, l

  l = len_trim (str)
  jj = 1
  ii = 1
  do while (ii .le. l)
    if (str(ii:ii) .ge. 'a' .and. str(ii:ii) .le. 'z') then
      ! lower case -> upper case
      str(ii:ii) = char (ichar(str(ii:ii)) - ichar('a') + ichar('A'))
    else if (str(ii:ii) .ge. 'A' .and. str(ii:ii) .le. 'Z') then
      ! Upper case: OK, nothing to do
    else
      ! Anything else: ignore, and do not use
      str = str (:ii-1) // str (ii+1:)    ! Skip the space
      l = l - 1                           ! reduce total length
      cycle                               ! without increment index ii.
    endif
    ii = ii + 1
  end do
end subroutine changeAllToUpcase


! ===========================================================================
! Prepare the Alphabet to use: it is the pass phrase, followed by the normal
! upper case alphabet, always avoiding duplicate letters
! ===========================================================================
subroutine setupAlphabet (argAlphabet, ResultAlphabet, argOmit_Q, argPassPhrase)

  character (len=*), intent(in)  :: argAlphabet
  character (len=*), intent(out) :: ResultAlphabet
  logical, intent(in) :: argOmit_Q     ! True: ompit Q in alphabet, , False: use I for both I and J
  character (len=*), intent(in) :: argPassPhrase
  integer :: ii, jj, l
  character :: cWork

  ResultAlphabet = ' '                                              ! Initialize result string
  call appendString (ResultAlphabet, argPassPhrase, argOmit_Q)      ! First use passprase
  call appendString (ResultAlphabet, argAlphabet, argOmit_Q)        ! and then use remaining letters from alphabet

end subroutine setupAlphabet


! ==================================================================================
! Append a string to an existing (possibly empty) string, avoiding duplicate letters
! ==================================================================================
subroutine appendString (ResultAlphabet, stringToAppend, argOmit_Q)

character (len=*), intent(inout) :: ResultAlphabet
logical, intent(in) :: argOmit_Q     ! True: omit Q in alphabet, , False: use I for both I and J
character (len=*), intent(in) :: stringToAppend
integer :: ii,jj,l
character :: cWork

jj = len_trim(ResultAlphabet) + 1                         ! here we start appending letters
l = len_trim (stringToAppend)                             ! count letters to add
do ii = 1, l
  if (jj .gt. l)    exit                                  ! Do not exceed resultant length
  cWork = stringToAppend (ii:ii)

  ! First make sure it's all in UPPER CASE.
  if (cWork .ge. 'a' .and. cWork .le. 'z')  then          ! lower case letter?
    cWork = char (ichar(cWork) -ichar('a') + ichar('A'))
  endif

  ! Now cWork is either in upper case or it is invalid (i.e. not in alphabet)
  if (cWork .ge. 'A' .and. cWork .le. 'Z') then           ! Valid?
    if (argOmit_Q) then                                   ! Q is not part of the valid applicable alphabet
      if (cWork .eq. 'Q')  cycle                          !   skip Q but conserve both I and J
    else
      ! dont omit Q, so use 'I' for both 'I' and 'J'
      if (cWork .eq. 'J') cWork = 'I'
    endif

    if  (jj .eq. 1) then
      ! filling very first letter of result alphabet
      ResultAlphabet (jj:jj) = cWork
      jj = jj + 1
    else if (index (ResultAlphabet (:jj), cWork) .eq. 0) then
      ! current work letter not yet contained in alphabet
      ResultAlphabet (jj:jj) = cWork
      jj = jj + 1
    else
      ! Nothing, just skip letters that are already known in result alphabet.
    endif
  else
    ! Nothing, just skip characters other than [A...Z]
  endif
end do

end subroutine appendString

! ===========================================
! Print original, encoded and decoded strings
! ===========================================
subroutine printResult (m1,m2,m3)
  character (len=*), intent(in) :: m1,m2,m3
  write (*,'("Original:  ", A)')  m1           ! original string unmodified
  call print1 (' Encoded: ', m2)               ! result of encode or decode:
  call print1 (' Decoded: ', m3)               ! print all groups of 2 letters
  print *
end subroutine printResult

! ===================================================================
! separate input string into groups of 2 letters and print all groups
! ===================================================================
subroutine print1 (comment, m)
  character (len=*), intent(in) :: comment, m
  integer :: ii
  write (*, '(A, X)', advance='no')   comment
  do ii=1, len_trim (m)-1,2
    write (*, '(A2,x)', advance = 'no') m(ii:ii+1)
  end do
  print *
end subroutine print1

! ================================================================================
! Print the resulting Polybius square based on the alphabet used for encode/decode
! ================================================================================
subroutine PrintSquare (Alphabet)
  character (len=*), intent(in)  :: Alphabet
  integer:: ii, l

  l = len_trim(alphabet)
  write (*,'(/,"Using this Polybius square for encode/decode:",/)')

  do ii=1, ColWidth*ColWidth
    write (*, '(A2)', advance='no')  Alphabet(ii:ii)
    if (mod (ii, ColWidth) .eq. 0) print *                      ! End of line
  end do
  print *                                                       ! one extra blank line
end subroutine PrintSquare


end program PlayferCipher
