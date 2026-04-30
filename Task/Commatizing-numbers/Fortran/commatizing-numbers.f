! Commatizing numbers
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
! Note that VSI Fortran on VMS does not compile this code because its current version
! cannot handle allocatable character strings
!
! U.B., August 2025
!
program commatisator

implicit none

logical, parameter ::DEBUG=.false.


call commatize("pi=3.14159265358979323846264338327950288419716939937510582097494459231", 3, 5)
call commatize("The author has two Z$100000000000000 Zimbabwe notes (100 trillion).", 1,3, '.') ! Use decimal point as separator
call commatize('"-in Aus$+1411.8millions"') ! Here the double quotes (") are part of the text.
call commatize("===US$0017440 millions=== (in 2000 dollars)")
call commatize("123.e8000 is pretty big.")
call commatize("The land area of the earth is 57268900(29% of the surface) square miles.")
call commatize("Ain't no numbers in this here words, nohow, no way, Jose.")
call commatize("James was never known as 0000000007", 0,3)
call commatize("Arthur Eddington wrote: I believe there are " // &
  "15747724136275002577605653961181555468044717914527116709366231425076185631031296"  // &
  " protons in the universe.")
call commatize("   $-140000±100 millions.")
call commatize("6/9/1946 was a good year for some.")

contains

subroutine commatize (text, astartIdx, agroupSize, aseparator)
  ! Arguments
  character(*), intent(in)          ::  text
  integer, intent(in), optional     :: astartIdx
  integer, intent(in), optional     :: agroupSize
  character, intent(in), optional   :: aseparator

  ! These variables are there even if optional args are omitted.
  integer                           :: startIdx
  integer                           :: groupSize
  character                         :: separator

  integer                           :: sz, ii
  integer                           :: ipBegin, ipPoint, ipEnd

  character(:), allocatable         :: newtext
  !
  ! Defaults for optional arguments
  ! and protect against invalid arguments
  if (present (astartIdx)) then
    startIDx = max (1, astartidx)
  else
    startIdx = 1
  endif
  if (present (agroupSize)) then
    groupsize = max(1, agroupsize)
  else
    groupsize = 3
  endif
  if (present (aseparator)) then
    separator = aseparator
  else
    separator = ','
  endif

  sz = len (text)
  ipBegin = 0
  ipPoint = 0
  ipEnd   = 0

  ! Find beginning and end of the first numeric part of the string
  do ii=startidx,sz
    if (isadigit (text(ii:ii), '1','9')) then           ! ignoring leading zeroes
      ipBegin = ii
      exit                                              ! Only the very first number is of any interest.
    else if (text(ii:ii) .eq. '.') then                 ! Leading Decimal point
      if (ii  .lt. sz) then
        if (isadigit (text(ii+1:ii+1), '0','9'))  then  ! must be followed by a valid digit
          ! Entire number starts here, it is something valid like ".123"
          if (DEBUG) print *, 'Decimal point detected at ii,sz= ', ii, sz
          ipBegin = ii
          ipPoint = ii
          exit
        endif
      endif
    end if
  end do

  ! Any number detected? Search for the end and, if necessary, the decimal point
  if (ipBegin .gt. 0 .and. ipBegin .le. sz) then
    do ii=ipBegin+1, sz+1
      if (ii > sz) then
        ipEnd = sz
      else if (text(ii:ii) .eq. '.' .and. ipPoint .eq. 0 .and. ii .lt. sz ) then
        if (isadigit (text(ii+1:ii+1), '0','9')) then   ! Decimal point must be followed by valid digit
          ipPoint = ii
        else
          ipEnd = ii-1                                  ! Might be valid decimal point, but terminates the number.
          exit                                          ! no need to continue, have found the end.
        endif
      else if (.not. isadigit (text(ii:ii), '0','9')) then    ! Anything other than a digit or point terminated the number.
        ipEnd = ii-1
        exit
      end if
    enddo
  end if

  ! Found a number?
  ! Three possibe cases: real number (>=1) with decimal point and digits before and after
  !                      real number (<1) starting with decimal point such as .71
  !                      integer number without decimal point.
  if (ipBegin .ne. 0) then                        ! Any nmumber
    if (ipPoint .gt. ipbegin) then                            ! Not starting with a decimal point but decimal point inside
      if (ipBegin .gt. 1) then
        newtext = text (:ipBegin-1)                           ! copy entire text before the numeric
      else
        newtext = ''                ! In any case variable 'newtext' must be initialized
      end if
      newtext = newtext  // setSeparators (text, ipPoint-1, ipBegin, &
                 groupsize, separator , requiredSize (ipPoint-1, ipBegin, groupsize))  // '.'
      newtext = newtext  // setSeparators (text, ipPoint+1, ipEnd,    &
                 groupsize, separator, requiredSize (ipPoint+1, ipEnd ,groupsize))
    else if (ipPoint .ne. 0 .and. ipPoint .lt. sz) then                  ! Starting with decimal point
      newtext = '.' //  setSeparators (text, ipPoint+1, ipEnd,    &
                     groupsize, separator, requiredSize (ipPoint+1, ipEnd,groupsize)  )
    else                                                                 ! Integer number
      newtext = text (:ipBegin-1) //  setSeparators (text, ipEnd, ipBegin,    &
                     groupsize, separator,  requiredSize (ipEnd, ipBegin, groupsize) )
    endif
    if (ipEnd .lt. sz) then
      newtext = newtext // text (ipend+1:)        ! Append alltext behind the number
    endif
  else                                            ! No number, just print straight copy
    newtext = text
  endif

  print '("Before: ", A)' ,  text
  print '(" After: ", A/)',  newtext


end subroutine commatize

  ! estimate how many separators wii be needed in a given range of digits
  ! and calculate the new tring length therefrom.
  function requiredSize (i0,i1,step) result (size)
    integer, intent(in) :: i0, i1, step
    integer             :: size
    integer             :: l,c

    l = iabs (i1-i0) + 1       ! Length of the string to be considered
    c = (l-1) / step           ! Number of separators to insert

    size = l + c
    end function requiredSize

  ! Insert separators into a numerical string
  function setSeparators (text, i0, i1, step, separator, resSize ) result (ntext )
    character(*), intent(in)  :: text           ! entire text
    integer, intent(in)       :: i0,i1          ! The numeric part goes from i0 to i1 (incl)
    integer, intent(in)       :: step           ! the group size between separators
    character, intent(in)     :: separator      ! the separator character
    integer, intent(in)       :: resSize        ! New size of result string
    character(len=resSize)    :: ntext          ! The resultant string, including th e separators
    integer :: ii, jj, cnt, direction           ! Helpers

    ! character-wise copy the old text into new text
    ! Loop index can go into either direction
    if (i0  .gt. i1 ) then
      direction = -1
    else
     direction = 1
    end if

    ! Position  of text(ii:ii) inside the resultant text
    if (i0 .lt. i1) then
      jj = 1
    else
      jj = resSize
    end if

    cnt = 0
    do ii = i0, i1, direction
      ntext (jj:jj) = text (ii:ii)      ! Copy characters
      jj = jj + direction
      cnt = cnt + 1                      ! count copied characters
      ! Group complete? Insert separator
      if (cnt .eq. step .and. jj .gt. 0 .and. jj .lt. resSize)  then
        ntext(jj:jj)  =  separator
        jj = jj + direction
        cnt = 0
      end if
    end do
  end function setSeparators

! Decide if a given character c is a digit in the range from "from" to "to".
function isadigit (c, from, to) result (YN)
  character, intent(in) :: c, from, to
  logical               :: YN

  YN = c>= from .and. c<=to
end function isadigit



end program commatisator
