!
! ADFGVX Cipher
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
! VSI Fortran on VMS does not compile it because it cannot handle
! allocatable character strings.
! U.B., December 2025
!==============================================================================

program ADFGVXCipher

  implicit none

  logical, parameter :: DEBUG = .false.     ! set to .true. for reproducable, not random results
  logical, parameter :: VERBOSE = .false.   ! set this to .true. to print some intermediate results
  integer, parameter :: maxLen=100          ! Maximum length of any test message (including extensions as 'X')

  integer, parameter :: minPassLen=7, maxPassLen=12   ! Minimum and maximum password length

  ! The complete alphabet of capital letters as used in most western languages, plus numbers 0...9
  character (len=36), parameter :: Alphabet ='ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567879'
  character (len=*), parameter :: ADFGVX = 'ADFGVX'

  character (len=maxLen)    :: MsgToEncrypt, DecryptedMsg
  character (len=2*maxLen) :: EncryptedMsg   ! encrypt makes 2 letters from 1
  character (len=25)        :: PassPhrase
  integer, parameter :: ColWidth = 6     ! depends on length of the used alphabet but we use only 36 letters

  character (len=36) :: PolyAlphabet      ! Permutation of Alphabet to represent Polybius square
  integer :: i

  ! Initialize random number generator once for the entire run-time of the program and all test cases
  call random_seed()


  ! The message to encrypt - for 1 test case
  ! the plain text message is from the task description
  MsgToEncrypt = 'ATTACKAT1200AM'

  if (.not. DEBUG) then
    print  '("Init: DEBUG is .false., i.e. password and Polybius square are randomized.")'
    PassPhrase = getRandomPassPhrase()       ! select random password from unixdict.txt
  else
    ! for DEBUG only: force constant password for reproducible result:
    print  '("Init: DEBUG is .true., i.e. the code reproduces results of the NIM solution")'
    PassPhrase = 'EXCURSION'  ! Taken from the NIM solution
  endif

  print '("Init: PassPhrase for encode and decode is ", A)' , PassPhrase

  if (.not. DEBUG) then
    call createRandomPolybiusSquare ()       ! Create random Permutation of Alphabet to represent Polybius square
  else
    ! For DEBUG only: force constant string for reproducable results
    ! Both the Alphabet and the password are from the NIM solution.
    ! If DEBUG is .true., the result of the NIM solution is exactly reproduced.
    PolyAlphabet =   'XOFPD6VHC40ZJMKRU5IA9YBW3L21NGQTE78S'
  endif

  call PrintSquare ("Init: Following Polybius square is used for encode/decode:", PolyAlphabet, ColWidth)

  call encode (MsgToEncrypt , EncryptedMsg, PolyAlphabet, PassPhrase)
  call decode (EncryptedMsg, DecryptedMsg, PolyAlphabet, PassPhrase)

  call printResult (MsgToEncrypt, EncryptedMsg, DecryptedMsg)

contains



! ==========================================================
! Find random length of the new password,
! then pick a random word of this length from the word list
! ==========================================================
function getRandomPassPhrase()   result (retval)
  character (len=maxPassLen) :: retval
  integer :: leng                                             ! required length of password to pick

  leng = randominInterval (minPassLen, maxPassLen)
  retval = getRandomWord (leng)

end function getRandomPassPhrase

! ==================================================================================
! Read the wordlist unixdict.txt and select a random word  with the requested length
! ==================================================================================
function getRandomWord (leng) result (retval)
  integer, intent(in) :: leng
  character (len=maxPassLen) :: retval

  character(len=100)  :: word                                     ! is longer than expected input word length
  character (len=maxPassLen), allocatable :: Candidates (:)
  integer:: capacity, content
  integer :: io_stat, l, idx, ii

  ! Read all words from unixdict.txt having length "len" and no repeating letters
  open(unit=10, file='unixdict.txt', status='old', action='read', iostat=io_stat)
  if (io_stat .ne. 0) then      ! File open MUST be successful, otherwise total program failure.
     print *, "Error opening file"
     stop
  end if
  capacity = 128
  call resize (Candidates, maxPassLen, capacity)
  content = 0
  do
    read (10,'(A)', iostat=io_stat)   word               ! ok for both intel and GNU.
    l = len_trim (word)                                  ! use this instead of Q format
    if (io_stat < 0) exit    ! EOF: Normal end of this loop
    if (io_stat > 0) then
      print *, "Read error" ! ERROR: (never seen)
      exit
    end if
    if (l .ne. leng) cycle
    if (hasDuplicateChars(word)) cycle
    if (content .eq. capacity) then
      capacity = capacity * 2
      call resize (Candidates, maxPassLen, capacity)
    end if
    content = content + 1
    Candidates (content) = word
  enddo
  idx = randominInterval (1, content)
  retval = candidates (idx)
  do ii=1, leng
    if (retval(ii:ii) .ge. 'a' .and. retval(ii:ii) .le. 'z') then
      retval(ii:ii) = char (ichar(retval(ii:ii)) - ichar('a') + ichar('A'))
    endif
  end do
  close (10)

end function getRandomWord

! ========================================================================
! Return true if argument word contains duplicate letters, otherwise false.
! ========================================================================
function hasDuplicateChars (word) result (itHas)
  character (len=*), intent(in) :: word
  logical :: itHas
  integer :: ii, jj, l
  l = len_trim(word)
  do ii=1, l
    do jj=ii+1, l
      if (word(ii:ii) .eq. word(jj:jj)) then
        itHas = .true.
        return
      endif
    end do
  end do
  itHas = .false.
end function hasDuplicateChars


  !==============================================================
  ! Creating a random Polybius square is equivalent with creating
  ! a random permutation of the used alphabet
  ! Use the Sattolo algorithm to create such a permutation .
  !==============================================================
subroutine createRandomPolybiusSquare ()

  character :: tmp                                      ! for swapping single letters

  integer :: j, k, l                                    ! Helper variables: indices into words, words' length


  PolyAlphabet = Alphabet
  l = len (Alphabet)
  do j = l, 1, -1                                       ! For all letters from end down to begin
    k = randominInterval (1, j-1)                       ! Select random letters between 1 and j-1
    tmp = PolyAlphabet(j:j)                             ! then swap letter at pos j with letter at pos k
    PolyAlphabet (j:j) = PolyAlphabet (k:k)
    PolyAlphabet (k:k) = tmp
  end do

end subroutine createRandomPolybiusSquare



! =============================================
! Increase allocated size of string array 'var'
! =============================================
subroutine resize(var, sLen, newSize)
  integer, intent(in)                              :: sLen       ! LEngth of 1 element of string array
  character (len=sLen), allocatable, intent(inout) :: var(:)     ! The array to be increased
  integer, intent(in)                              :: newSize    ! The new size of var
  character (len=sLen), allocatable                :: tmp(:)     ! Temporary storage
  integer                                          :: oldSize    ! Current array size
  integer                                          :: ii         ! Loop index

  ! Copy allocated values to temporary, then allocate var with
  ! new size and copy back saved values.
  ! Could be done with move_alloc but this would not be portable to OpenVMS Fortran

  if (allocated(var)) then
    oldSize = size(var)
  else
    oldSize = 0
  end if

  if (newSize .gt. oldSize) then           ! only increment
    if (oldSize .gt.0) then
      allocate(tmp (oldSize))
      tmp(:oldSize) = var(:oldSize)
      deallocate (var)
    end if
    allocate(var(newSize))
    if (allocated(tmp) .and. allocated (var) ) then
      oldSize = min(size(tmp, 1), size(var, 1))
      var(:oldSize) = tmp(:oldSize)
      deallocate (tmp)
    end if
  end if
end subroutine resize


  ! ===========================================================
  ! Generate random number between @lo and @hi (inclusive)
  ! Assume Random Number Generator has been initialized before.
  ! ===========================================================
function randominInterval (lo, hi) result (r)
  integer, intent(in) :: lo, hi                         ! the interval
  integer :: r                                          ! resultant (pseudo-)random number
  real :: rnd                                           ! Fortran random number generator generates float values

  call random_number (rnd)
  r = lo + FLOOR((hi+1-lo)*rnd)                         ! We want to choose one between [lo,hi]

end function randominInterval



! =============================================
! Encode a given string using the ADFGVX Cipher
! =============================================
subroutine encode (argInString, outString, argAlphabet, argPassPhrase)
  character (len=*), intent(in)  :: argInString     ! The string to encode
  character (len=*), intent(out) :: outString       ! The resultant encoded text
  character (len=*), intent(in)  :: argAlphabet     ! The alphabet that makes the Polybius square
  character (len=*), intent(in) :: argPassPhrase    ! the password used for encode and also decode.
  integer :: nRow
  integer :: argLen, passLen, newlen, ii, jj, kk, row, col
  character(len=2*len(OutString)+len_trim(argPassPhrase))  newAlphabet

  character, dimension(:,:), allocatable :: Matrix, expandedMatrix

  argLen = len_trim (argInString)
  passLen = len_trim (argPassPhrase)
  newlen = len(OutString)+len_trim(argPassPhrase)
  ! 1st step: encode with the given alphabet (resp. the equivalent 6x6 square),
  ! the output string being the row/col of each letter, expressed in terms of ADFGVX
  outString = ' '
  jj = 1
  do ii=1,argLen
    call getRC (argInString(ii:ii),row,col, argAlphabet)
    outString (jj:jj) = ADFGVX (row:row)
    jj = jj + 1
    outString (jj:jj) = ADFGVX (col:col)
    jj = jj + 1
  end do

  if (VERBOSE) then
    print '("Encode, first step: ")'
    do ii=1, arglen
      write (*,'(A3)', advance='no') ArgInString (ii:ii)
    end do
    print *, 'becomes'

    do ii=1, 2*argLen, 2
      write (*,'(x,A2)', advance='no') outString (ii:ii+1)
    end do
    write (*,'(///)')
  endif

  jj = 1
  kk = 1
  newAlphabet = argPassPhrase (:passLen) // outString(:len_trim(outString))

  nRow = (len_trim (newAlphabet) + passLen - 1)/passLen ! Required net number of lines for the Matrix
  allocate (Matrix (passLen, nRow))

  ! Without any complications: Just accept that last line might be incomplete - complete it with spaces.
  do row=1, nRow
    do col=1,passLen
      if (row .eq. 1 ) then                             ! Top row gets the password
        Matrix (col,row) = newAlphabet (jj:jj)
        jj = jj + 1
      else
        if (jj .gt. len_trim(newAlphabet)) then         ! Entire new alphabet copied to Matrix
          Matrix(col,row) = ' '                         ! remaining Matrix is all blank
        else
          Matrix (col,row) = newAlphabet (jj:jj)
          jj = jj + 1
        endif
      endif
    end do
    if (jj .gt. len_trim(newAlphabet)) exit
  end do
  jj = 1
  do row=1, nRow
    do col=1,passLen
      newAlphabet (jj:jj) = Matrix (col,row)
      jj = jj + 1
    end do
  end do

  if (VERBOSE) &
    call printMatrix ('Encode: This results in a new matrix: ', Matrix, nRow, passLen)
  ! Sort columns
  call quicksort_matrix (Matrix, passLen, nRow, 1, passlen)

  if (VERBOSE) &
    call printMatrix ('Encode: After sorting columns, this becomes: ', Matrix, nRow, passLen)

  jj = 1
  do row=1, nRow
    do col=1,passLen
      newAlphabet (jj:jj) = Matrix (col,row)
      jj = jj + 1
    end do
  end do

  allocate (expandedMatrix (passLen, nRow))
  ! Initialize al to blank
  do row=1, 2*kk
    do col=1,passLen
      expandedMatrix (col,row) = ' '
    end do
  end do

  jj=1
  do row=1, nRow
    do col=1,passLen
      if (jj .le. len_trim(newAlphabet))  then
        expandedMatrix (col,row) = newAlphabet (jj:jj)
      else
        expandedMatrix (col,row) = ' '
      endif
      jj = jj + 1
    end do
  end do

  outString = ' '
  jj = 1
  do col=1,passLen
    do row=2, nRow
      if (expandedMatrix (col,row) .ne. ' ') then
        outString (jj:jj) = expandedMatrix (col,row)
        jj = jj + 1
      end if
    end do
    outString (jj:jj) = ' '
    jj = jj + 1
  end do

end subroutine encode


! ==================================================================================
! Sort columns of a Matrix, taking elements of top row as key to decide "lt" or ge".
! ==================================================================================
recursive subroutine quicksort_matrix (mat, ncols, nrows, low, high)

  integer, intent(in) :: ncols,nrows
  character, dimension (ncols,nrows), intent(inout) :: mat

  integer, intent(in) :: low, high
  integer :: pivot_index
  integer :: i, j, mid
  character :: pivot, temp

  if (low .lt. high) then
    ! The list is already "almost sorted", so use midlle word as pivot.
    mid = low + (high-low) / 2
    pivot = mat (mid,1)

    !Move pivot to the end
    call swapMat (mat,ncols,nrows,mid,high)

    i = low - 1
    do j = low, high - 1
      if (mat(j,1) .le. pivot) then
        i = i + 1
        call swapMat (mat,ncols,nrows,i,j)
      end if
    end do

    call swapMat (mat,ncols,nrows,i+1,high)
    pivot_index = i + 1

    call quicksort_matrix (mat, ncols,nrows, low, pivot_index - 1)
    call quicksort_matrix (mat, ncols,nrows,  pivot_index + 1, high)
  end if
end subroutine quicksort_matrix

! ===============================================
! Swap two columns of a Matrix (Used for sorting)
! ===============================================
subroutine swapMat (mat,ncols,nrows,col1,col2)
  integer, intent(in) :: ncols,nrows                        ! Size of ...
  character, dimension (ncols,nrows), intent(inout) :: mat  ! ... the matrix
  integer, intent(in) :: col1, col2                         ! The 2 columns to swap

  character :: tmp                                    ! Helpers to swap 2 elements
  integer :: row

  ! early return in trivial noop case
  if (col1 .eq. col2) return

  do row=1, nrows                                    ! Swap all elements of col 1 and col 2
    tmp = mat (col1,row)
    mat (col1,row) = mat(col2,row)
    mat(col2,row) = tmp
  end do

end subroutine swapMat

! =======================================================
! Decode a given (encoded) string using the ADFGVX Cipher
! =======================================================
subroutine decode (argInString, outString, argAlphabet, argPassPhrase)
  character (len=*), intent(in)  :: argInString     ! The encoded string to decode
  character (len=*), intent(out) :: outString       ! Result of the decode
  character (len=*), intent(in)  :: argAlphabet     ! The Polybius Square to encode and decode
  character (len=*), intent(in) :: argPassPhrase    ! The Password used to encode and decode
  character (len=MaxLen) :: tmpString               ! Temporary torage for intermediate result
  character, allocatable :: Matrix (:,:)            ! Matrix to constructed from input string
  character (len=:),allocatable :: SortedPassPhrase ! The password after sorting its letters
  integer :: nRow, passLen                          ! NMUmbner of rows and columns of above Matrix
  integer :: inLen, col,row, ii, jj, idx            ! Length of input string, and some helpers

  ! Estimate input string lengths
  inLen = len_trim (argInString)
  passLen = len_trim (argPassPhrase)

  outString = ' '
  nRow = (inLen + (passLen-1)) / passLen  + 1     ! 1 extra for top row = password

  allocate (Matrix (passLen, nRow))

  ! Initialize entire matrix
  do col=1,passLen
    do row=1, nRow
      Matrix (col,row) = ' '
    end do
    ! Fill the column as far as required
  end do


  ! The columns of the result matrix are sorted as password letters and
  ! the sorted password letters makeup top row of th is matrix
  SortedPassPhrase = argPassPhrase
  call  quicksort_matrix (SortedPassPhrase, passlen,  1, 1, passlen)

  row=1
  do col=1, passLen
    Matrix (col,row) = SortedPassPhrase(col:col)
  end do

  ! Set rest ( row 2 ff.) of the Matrix: column by column
  jj = 1
  do col=1,passLen
    row = 2
    do while (argInString (jj:jj) .ne. ' ')
      Matrix (col,row) = argInString (jj:jj)
      jj = jj + 1
      row = row + 1
    enddo
    jj = jj + 1
  end do

  if (VERBOSE) &
    call printMatrix ('Decode: the reconstructed Code matrix is ', Matrix, nROw, passLen)

  ! We know the columns of this matrix are sorted together with the password
  !
  ! restore the correct order of thet sorted matrix
  call UndoSort (Matrix, passLen, nRow, argPassPhrase, passlen)

  if (VERBOSE) &
    call printMatrix ('Decode: After Undo Sorting, this becomes', Matrix, nRow, passLen)

  ! The matrix is in the correct order now, so its rows, one by one,  represent the first encoded string
  !
  jj = 1
  tmpString = ' '
  do row = 2, nRow          ! Skip top row (=Passwprd)
    do col=1,passLen
      tmpString (jj:jj) = Matrix(col,row)
      jj = jj + 1
    end do
  end do

  ! Now we have the encoded string, each 2 letters are row/col in ADFGVX scheme
  jj = 1
  do ii=1, len_trim(tmpString), 2
    row = index (ADFGVX, tmpString(ii:ii))
    col = index (ADFGVX, tmpString((ii+1) : (ii+1)))
    outString (jj:jj) = getChar (row,col,argAlphabet)   ! Decode from row/col to clear text
    jj = jj + 1
  end do
end subroutine decode

! =============================================================================
! Print all nRow x nCol elements of a Matrix, togehther with a descriptive text
! =============================================================================
subroutine printMatrix (comment, Matrix, nRow, nCol)
  integer, intent(in) :: nRow, nCol
  character (len=*), intent(in) :: Comment
  character , intent(in) :: Matrix (nCol, nRow)
  integer :: r, c

  write (*,'(/A/)')  Comment
  do r=1, nROw
    do c=1, nCol
      write (*, '(A2)', advance='no')  Matrix(c,r)
    end do
    write (*,*)
  end do
end subroutine printMatrix

!=============================================================
! Matrix has been sorted before, with top row as key elements.
! Here undo that sort operation
!=============================================================
subroutine UndoSort (Matrix, nCol, nRow, argPassPhrase, passLen)
  integer, intent(in) :: nCol, nRow, passLen
  character, intent(inout)  :: Matrix (nCol, nROw)
  character                 :: resultMatrix (nCol, nROw)

  character (len=passLen), intent(in) :: argPassPhrase

  integer :: ii, jj, kk

  do ii=1, passLen
    ! find whatever letter should be at pos ii within the unscrambled string
    jj = index (argPassPhrase, Matrix(ii, 1) )
    ! so letter "PassPhrase(jj:jj)" should be at pos ii in line 1 of Matrix
    if (jj .ne. ii) then
      do kk=1, nRow
        resultMatrix (jj,kk) = Matrix(ii,kk)
      end do
    else
      do kk=1, nRow
        resultMatrix (jj,kk) = Matrix(jj,kk)
      end do
    endif
  end do
  matrix = resultMatrix
end subroutine UndoSort


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

! ===========================================
! Print original, encoded and decoded strings
! ===========================================
subroutine printResult (m1,m2,m3)
  character (len=*), intent(in) :: m1,m2,m3
  write (*,'("Original:  ", A)')  m1(:len_trim(m1))
  write (*,'(" Encoded:  ", A)')  m2(:len_trim(m2))
  write (*,'(" Decoded:  ", A)')  m3(:len_trim(m3))
  print *
end subroutine printResult

! ================================================================================
! Print the resulting Polybius square based on the alphabet used for encode/decode
! ================================================================================
subroutine PrintSquare (Comment, Alp, cw)
  character (len=*), intent(in) :: Comment
  character (len=*), intent(in)  :: Alp
  integer, intent(in) :: cw                                     ! column width for dormatted display
  integer:: ii, l

  l = len_trim(alp)
  write (*,'(/A/)')  Comment
  Write (*, "('   A D F G V X', /,' +------------',/  A, '|')", advance='no') ADFGVX (1:1)
  do ii=1, l
    write (*, '(A2)', advance='no')  Alp(ii:ii)
    if (mod (ii, cw) .eq. 0) then
      if (ii .ne. l)  then
        write (*,'(/,A1,"|")', advance='no') ADFGVX (1 +  ii/cw:1 +  ii/cw)
      else
        write (*,*) ! just EOL
      endif
    endif
  end do
  print *                                                       ! one extra blank line
end subroutine PrintSquare


end program ADFGVXCipher
