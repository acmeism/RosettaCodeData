!
! Autogram checker
!
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3

! U.B., August 2025
!

program AutogramChecker

implicit none

! Punctuation signs used in more than 1 internal subroutines/fubnctions
!
  integer, parameter  :: npunct=8     ! this is for parsing text that might be in plural form
  integer, parameter  :: nunique=4    ! this is the number of distinct punctuation signs
  character (len=17)  :: punct(npunct) =  ['comma           ','hyphen          ',  &  ! first come the singular forms
                                           'apostroph       ','exclamation     ',  &  !
                                           'commas          ','hyphens         ',  &  ! and then the plural forms
                                           'apostrophe      ','apostrophes     ']
  character           :: cpunct(npunct) = [','              ,'-', &   ! same as above 8 phrases
                                           "'"              ,'!', &
                                           ','              ,'-', &   ! these are duplicates
                                           "'"              ,"'"]

! Are the sentences listed in the task description autograms?
call check (.false., "This sentence employs two a's, two c's, two d's, twenty-eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty-five s's, twenty-three t's, six v's, ten w's, two x's, five y's, and one z.")
call check (.false., "This sentence employs two a's, two c's, two d's, twenty eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's, ten w's, two x's, five y's, and one z.")
call check (.true., "Only the fool would take trouble to verify that his sentence was composed of ten a's, three b's, four c's, four d's, forty-six e's, sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's, four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's, forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's, eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens and, last but not least, a single !")
call check (.false., "This pangram contains four as, one b, two cs, one d, thirty es, six fs, five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns, fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us, seven vs, eight ws, two xs, three ys, & one z.")
call check (.false., "This sentence contains one hundred and ninety-seven letters: four a's, one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's, twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's, nineteen t's, six u's, seven v's, four w's, four x's, five y's, and one z.")
call check (.false., "Thirteen e's, five f's, two g's, five h's, eight i's, two l's, three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's, six w's, four x's, two y's.")
call check (.true.,"Fifteen e's, seven f's, four g's, six h's, eight i's, four n's, five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's, three x's.")
call check (.false., "Sixteen e's, five f's, three g's, six h's, nine i's, five n's, four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's, four z's.")

contains

! Analyses a given text, and prints if it is am autogram, i.e. every statement it makes
! about the number of certain letters it contains is true. This may or may not include
! punctuation characters.
!
subroutine check (IncludingPunctuation, text)

  logical, intent(in)           :: IncludingPunctuation
  character (*), intent(in)     :: text
  integer                       :: textlen
  integer                       :: ii,jj
  integer                       :: charText(255)      !  Character count of text
  integer                       :: charParsed(255)    !  Character count as parsed from the text

  logical                       :: isAutogram, isAutogramWithPunctuation
  character*100                 :: Reason (30)        ! Maximum wrong: 26 for [a-z], 4 for punctuation marks
  integer                       :: reasoncount

  textlen = len_trim (text)
  call pretty_print (text)

  reasoncount = 0

  charText = countLetters (text, textlen)
  ! For correct search of keywords like " ten", we need leading space, otherwise
  ! text "ten" inside other words like in "sentence" would give false results.
  charParsed = parseText (' ' // text, textLen+1, IncludingPunctuation)

  isAutogram  = .true.
  isAutogramWithPunctuation = .true.

  ! Now compare the results of letter counting and text analysis...
  do ii=11, 255
    if (.not. IncludingPunctuation) then
      if (ii .lt. ichar('a') .or. ii .gt. ichar('z'))  cycle      ! skip all characters other than 'a'...'z'
    else
      ! Separately check for all punctuation signs.
      ! Note that, unlike normal characters, if they are part of the text, the text must specify their count.
      do jj=1, nunique
        if (ii .eq. ichar(cpunct(jj))) then
          if (charText (ichar(cpunct(jj))) .ne. charParsed(ichar(cpunct(jj)))) then
            reasoncount = reasoncount + 1
            if (charText(ichar(cpunct(jj))) .gt. 1 ) then     ! use plural
              if (charParsed(ichar(cpunct(jj))) .gt. 0) then
                write (Reason(reasoncount), '( "It contains ", i0, " punctuation signs ", A1,  &
                  " but according to the text there should be ", i0)') &
                   charText(ichar(cpunct(jj))),  cpunct(jj), charParsed(ichar(cpunct(jj)))
              else
                write (Reason(reasoncount), '( "It contains ", i0, " punctuation signs ", A1,  &
                  " but the text does not mention them")') &
                   charText(ichar(cpunct(jj))),  cpunct(jj)
              end if
            else                                               ! use singular
              if (charParsed(ichar(cpunct(jj))) .gt. 0) then
                write (Reason(reasoncount), '( "It contains ", i0, " punctuation sign", A1,  &
                  " but according to the text there should be ", i0)') &
                  charText(ichar(cpunct(jj))),  cpunct(jj), charParsed(ichar(cpunct(jj)))
              else
                write (Reason(reasoncount), '( "It contains ", i0, " punctuation sign ", A1,  &
                  " but the text does not mention it")') &
                   charText(ichar(cpunct(jj))),  cpunct(jj)
              end if
            endif
            isAutogramWithPunctuation = .false.
          end if
        endif
      enddo
    endif
    if (charText(ii) .ne. charParsed(ii) .and. charParsed(ii) .gt. 0)  then
      reasoncount = reasoncount + 1
      if (charText(ii) .gt.1 ) then
        write (Reason(reasoncount),'("It contains ", i0, x, A1,"''s ", &
          " but according to the text there should be ", i0  )' ) &
            charText(ii),  char(ii), charParsed(ii)
      else
        write (Reason(reasoncount),'("It contains ", i0, x, A1, &
          " but according to the text there should be ", i0  )' ) &
            charText(ii),  char(ii), charParsed(ii)
      end if
      isAutogram = .false.
    end if
  enddo

  if (isAutogram .and. isAutogramWithPunctuation)  then
    if (IncludingPunctuation) then
      print '( "is a punctuation-including autogram.")'
    else
      print '("is an autogram.")'
    endif
  else
    if (IncludingPunctuation) then
      print '("is not a punctuation-including autogram.")'
    else
      print '("is not an autogram.")'
    endif
  endif

  if (reasoncount .gt. 0) then
    print '("Reason:" )'
    do ii=1, reasoncount
      print '(A)', Reason(ii)
    end do
  end if

  print *

end subroutine check

! Print the input sentence with an introducting line,
! then each line indented and limited to maximum length.
subroutine pretty_print (text)
  character (*), intent(in)     :: text
  integer, parameter            :: linelength = 80
  integer, parameter            :: indentlength = 4
  character (len=indentlength)  :: indent = ' '
  integer :: ip, jp

  integer :: textlen
  textlen = len_trim (text)
  jp = 0
  ip = 0
  print '("The sentence ")'                             ! Introducting line
  do while (ip .le. textlen)
    ip = min (textlen, jp + linelength - indentlength)  ! last letter to print in current line

    if (ip .lt. textlen) then                           ! The end has not been reached...
      !  we go back to previous space
      do while (ip .ge. jp .and. text(ip:ip) .ne. ' ')
        ip = ip - 1
      end do
    endif
    print ('(A,A)'),  indent, text(jp+1:ip)
    jp = ip     ! points to the last already printed character
    ip=ip+1     ! points 1 behind last printed character
  enddo


end subroutine

! Simply count letters of the given text, and returns the frequencies (including zero)
! of all 255 letters of the ASCII table.
!
function countLetters (text, length) result(histo)
  character (*), intent(in)     :: text
  integer, intent(in)           :: length
  integer                       :: histo(255)
  integer                       :: ii, c
  character                     :: ch
  histo = 0
  do ii=1, length
    ch = text(ii:ii)
    c = ichar (ch)
    if (ch .ge. 'A' .and. ch .le. 'Z') then
      c = c - ichar('A') + ichar ('a')
    endif
    histo(c) = histo(c) + 1
  enddo
end function countLetters

! Analyse the text and fill the parsed number into the histogram of frequencies
! e.g. if the text contains the phrase "twenty-four a's", then histo(97) will be  24
!
function parseText (text, length, IncludingPunctuation ) result(histo)
  character (*), intent(in)         :: text                   ! The text to analyze...
  integer, intent(in)               :: length                 ! ... and its length
  logical, intent(in)               :: IncludingPunctuation   ! if .true., dont ignore punctuation signs

  integer                           :: histo(255)             ! Frequency of usage for all possible characters
  integer                           :: ii, c                  ! Little helpers

  character (len=100), allocatable  :: words (:)              ! All relevant words of hte incoming sentence
  integer   :: nwords                                         ! word count

  ! Possible textual representation of ten-digits (except 'ten')
  integer, parameter  :: ntens=8
  character (len=7)   :: tens(ntens) = ['twenty ','thirty ','forty  ','fifty  ','sixty  ','seventy','eighty ','ninety ']
  ! Single word numbers: 1...19
  integer, parameter  :: nones=20
  character (len= 9)  :: ones(nones) = ['single   ','one      ','two      ','three    ','four     ', &
                                        'five     ','six      ','seven    ','eight    ','nine     ', &
                                        'ten      ','eleven   ','twelve   ','thirteen ','fourteen ', &
                                        'fifteen  ','sixteen  ','seventeen','eighteen ','nineteen ' ]

  integer :: iTen, iOne, iPunct, iCount    ! Little helpers

  ! Separate sentence into array of words
  call tokenize (text, length, IncludingPunctuation, words, nwords)

  ! Go through the words, looking for numbers
  ii = 0                                ! to be incremented at top of following loop
  histo = 0                             ! Clear all elements
  do while (ii.lt.nwords)               ! do nothing if nwords is 0 (unlikely)
    ii = ii + 1                         ! Next word
    iCount = 0                          ! Resultant number
    iTen = find (needle = words(ii), haystack=tens)
    if (iTen .ne. 0) then
      ! We have the tens digit (in cases the number is >=20)
      ! following either the ones digit, or, if absent, the letter that is counted, or
      ! the punctuation symbol or the punctuation text.
      ! this is ambiguous: "twenty-three e's" can be 20 "-" and 3 "e", or it is 23 "e"
      ! We assume the first case: twenty- means 20 "e" if IncludingPunctuation argument is .true.
      iCount = 10*(iTen+1)              !  "+1" because the tens array starfts at 1=twenty.
      if (ii .lt. nwords) then
        ii = ii + 1                                         ! look at next word
        if (words(ii)(1:1) .eq. '-') then
          ! a hyphen following ten-digit usually means one-digit is following
          ! Lets see if the hyphen is followed by a one-digit. If so,
          ! complete the number with ten- and one digit
          if (ii .lt. nwords) then
            iOne = find (needle = words(ii+1), haystack=ones)   ! looking for one-digit
            if (iOne .ne. 0) then
              ii = ii + 1     ! is .le. nWords now, so its OK.
            endif
          endif
        else if (IncludingPunctuation) then
          ! at this point we expect either a punctuation symbol, or one of the
          ! punctuation strings like "comma", or the ones digit
          iPunct = find (needle = words(ii), haystack=cpunct)   ! looking for punctuation sign
          if (iPunct .eq. 0) iPunct = find (needle = words(ii), haystack=punct)
          if (iPunct .ne. 0) then
            ! We have 20...90 punctuation signs of type cpunct(iPunct)
            histo (ichar(cpunct(ipunct))) = iCount          ! Have solution for this counter.
            cycle                                           ! go to next number
          endif
        end if
        ! Here we either have found 20-90 punctuation marks, or we have only the ten-digit.
      else
        ! We have a ten-digit but nothing more since we reached the end of the word list.
      endif
    end if
    ! Come here if we have not found (or not looked for) a punctuation mark.
    ! And we may or may not have found the ten-digit. now see if there is a one-digit
    !
    iOne = find (needle = words(ii), haystack=ones)   ! looking for one-digit
    if (iOne .ne. 0) then
      if (iOne .le. 2) then
        iCount = iCount  + 1
      else
        iCount = icount + iOne - 1
      endif
      ! Now we must search for punctuation (sign or textual), or
      ! the next letter is what the number c
      if (IncludingPunctuation) then
        ! at this point we expect either a punctuation symbol, or one of the
        ! punctuation strings like "comma", or the ones digit
        iPunct = find (needle = words(ii+1), haystack=cpunct)   ! looking for punctuation sign
        if (iPunct .eq. 0) iPunct = find (needle = words(ii+1), haystack=punct)
        if (iPunct .ne. 0) then
          ! We have 20...90 punctuation signs of type cpunct(iPunct)
          histo (ichar(cpunct(ipunct))) = iCount        ! Have solution for this counter.
          cycle                                         ! go to next number
        endif
      end if
      ! Here if punctuation not found or not searched.
      ii = ii + 1

      if (ii .le. nwords) then
        ! next letter is fist letter of the now current word.
        histo (ichar(words(ii)(1:1))) = iCOunt        ! Have solution for this counter.
        cycle                                           ! go to next number
      endif
    end if
  end do
end function parseText

! Split a text into an array of words
subroutine tokenize (text, length, IncludingPunctuation, tokens, ntokens)
  character (*), intent(in)     :: text                         ! The text to split ...
  integer, intent(in)           :: length                       ! ... and its lengh
  logical, intent(in)           :: IncludingPunctuation         ! If .true., punctuation signs are not ignored, but words on their own
  character (len=100), allocatable, intent(out)  :: tokens (:)  ! The resultant array of words...
  integer, intent(out)          :: ntokens                      ! and its length

  integer                       :: capacity                     ! max capacity of output array
  integer                       :: lo, hi, ii                   ! little helpers

  hi = 0
  lo = 1
  ntokens = 0

  ! start with moderate 100 words, to be increased if necessary
  capacity = 100
  call resize (tokens, capacity)

  do while (hi .lt. length)
    ! skip spaces or punctuation to find beginning of next word
    do while ((text(lo:lo) .lt. 'a' .or. text(lo:lo) .gt. 'z') .and. (text(lo:lo) .lt. 'A' .or. text(lo:lo) .gt. 'Z') )
      lo = lo + 1
      if (lo .ge. length) then
        hi=lo+1
        EXIT
      endif
    end do
    ! find next space or punctuation mark to detect end of next word
    hi = lo
    do while (text(hi+1:hi+1) .ge. 'a' .and. text(hi+1:hi+1) .le. 'z')
      hi = hi + 1
      if (hi .ge. length) then
        EXIT
      endif
    end do

    if (lo .ge. 1 .and. hi .le. length) then
      ntokens = ntokens + 1
      if (ntokens .gt. capacity) then
        capacity = 2*capacity
        call resize (tokens, capacity)
      endif
      do ii=lo,hi
        if (text(ii:ii) .ge. 'A' .and. text(ii:ii) .le. 'Z')   then
          tokens (ntokens)(ii-lo+1:ii-lo+1) = char( ichar(text (ii:ii))-ichar('A')+ichar('a'))  ! tolower
        else
          tokens (ntokens)(ii-lo+1:ii-lo+1) = text (ii:ii)
        end if
      end do
      lo = hi+1
      if (hi .lt. length) then
        if (IncludingPunctuation .and. text(hi+1:hi+1) .ne. ' ') then
          ntokens = ntokens + 1
          if (ntokens .gt. capacity) then
            capacity = 2*capacity
            call resize (tokens, capacity)
          endif
          tokens(ntokens) = text (hi+1:hi+1)  ! could be punctuation mark
          hi = hi + 1
          lo = hi
        endif
      endif
    end if
  end do
end subroutine tokenize

!
! Find a word in a list of possible keywords.
! Returns index of the word in that array, or 0 if not found.
!
function find (needle, haystack) result(index)
  character (*) , intent(in)  :: needle
  character (*), intent(in)   :: haystack(:)
  integer                     :: Index

  do index=1, size(haystack)
    if (len_trim (needle) .eq. len_trim(haystack(index))  ) then                      ! Lenths match
      if (needle (:len_trim (needle)) .eq. haystack(index)(:len_trim (needle))) then  ! Text identical
        return                                                                        ! Have the solution
      endif
    endif
  end do
  ! Here if needle is not in haystack. 0 signals fault.
  index = 0
end function find


! CHange but only increase allocated size of string array 'var'
subroutine resize(var, newSize)
  character (len=100), allocatable, intent(inout) :: var(:)           ! The array to be increased
  integer, intent(in)                             :: newSize          ! The new size of var
  character (len=100), allocatable                :: tmp(:)           ! Temporary storage
  integer                                         :: oldSize          ! Current array size
  integer                                         :: ii               ! Loop index

  ! Copy allocated values to temporary, then allocate var with
  ! new size and then copy back saved values.
  ! Could do it with move_alloc but this would not be portable to OpenVMS Fortran
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
    do ii=oldSize+1, newSize
      var (ii)(1:) = ' '
    end do
  end if
end subroutine resize

end program AutogramChecker
