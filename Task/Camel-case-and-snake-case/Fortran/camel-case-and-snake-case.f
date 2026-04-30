! Camel case and snake case
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!
!
! U.B., August 2025
!
program CaseConverter

implicit none

! sep is a marker to separate words within given strings.
! Selected "§" because this is never part of a legit text.
!
character, parameter  ::  sep='§'

character (len=:), allocatable :: testWord


print *, ' ***** Converting test strings to Snake Case *****'

testWord = 'snakeCase'
call printResult (testWord, toSnakeCase (testWord))

testWord = 'snake_case'
call printResult (testWord, toSnakeCase (testWord))

testWord = 'variable_10_case'
call printResult (testWord, toSnakeCase (testWord))

testWord = 'variable10Case'
call printResult (testWord, toSnakeCase (testWord))

testWord = 'ɛrgo rE tHis'
call printResult (testWord, toSnakeCase (testWord))

testWord = 'hurry-up-joe!'
call printResult (testWord, toSnakeCase (testWord))

testWord = 'c://my-docs/happy_Flag-Day/12.doc'
call printResult (testWord, toSnakeCase (testWord))

testWord = '  spaces  '
call printResult (testWord, toSnakeCase (testWord))

print *
print *, ' ***** Converting test strings to Camel Case *****'

testWord = 'snakeCase'
call printResult ( testWord, toCamelCase (testWord) )

testWord = 'snake_case'
call printResult ( testWord, toCamelCase (testWord) )

testWord = 'variable_10_case'
call printResult ( testWord, toCamelCase (testWord) )

testWord = 'variable10Case'
call printResult ( testWord, toCamelCase (testWord) )

testWord = 'ɛrgo rE tHis'
call printResult (testWord, toCamelCase(testWord))

testWord = 'hurry-up-joe!'
call printResult ( testWord, toCamelCase (testWord) )

testWord = 'c://my-docs/happy_Flag-Day/12.doc'
call printResult ( testWord, toCamelCase (testWord) )

testWord = '  spaces  '
call printResult ( testWord, toCamelCase (testWord) )




contains


! ----------------------------------------------------------
! print with variable format to display the greek "ɛ"
! and the following text positioned correctly.
! Letter "ɛ"  uses 2 bytes so len("ɛ") = 2 but ulen("ɛ") = 1
! ----------------------------------------------------------

subroutine printResult (a,b)
character*(*), intent(in)  :: a,b
character (len=100) ::fmt
write (fmt, *) '(A', 34+ (len(a)-ulen(a)) ,', " => ",A)'
print fmt, a, b

end subroutine printResult


!---------------------------------------
! change ASCII a...z to upper case a...z
!---------------------------------------
function toupper (c) result(retc)

character ::c
character :: retc

if (c >='a' .and. c <= 'z') then
  retc = achar (iachar('A') + (iachar(c)-iachar('a')))
else
  retc = c
end if

end function toupper

!---------------------------------------
! change ASCII A...Z to lower case a...z
!---------------------------------------
function tolower (c) result(retc)

character ::c
character :: retc

if (c >='A' .and. c <= 'Z') then              !  is upper case
  retc = achar (iachar('a') + (iachar(c)-iachar('A')))
else
  retc = c
end if

end function tolower

!---------------------------------------------------------------------------------
! Scan input text, mark all positions between distinct words within the text
! so that later in the actual conversion these points can be rewritten accordingly.
!---------------------------------------------------------------------------------
function  prepare (txt)  result (newtext)

character (len=*), intent (in) :: txt
character (len=:), allocatable  :: text, newtext
integer :: ip1, ip2, ip3, l
character :: beginword


newtext='';

! First remove leading and trailing spaces
text = trim (txt)
text = adjustl (text)
text = trim (text)
l = len_trim(text)

ip1 = 1
ip2 = 2
ip3 = 1
do while (ip2 <= l)
  if (text(ip2:ip2) >= 'A' .and. text(ip2:ip2) <='Z' ) then               ! upcase letter indicates beginning of a word
    newtext = newtext(:len_trim(newtext)) // text(ip1:ip2-1) // sep
    ip1 = ip2
    ip2 = ip1+1
  else if (text(ip2:ip2) .eq. '_'  &
      .or. text(ip2:ip2) .eq. '-'  &
      .or. text(ip2:ip2) .eq. ' ' ) then    ! Separator is behind current word, new word following.
    if (ip2 .lt. l) then ! ip2+1 still inside text
      beginword = tolower (text(ip2+1:ip2+1))
      newtext = newtext(:len_trim(newtext)) // text (ip1:ip2-1) // sep  // beginword
    else
      ! separator at ip2 is last character of text. Just drop it.
      newtext = newtext(:len_trim(newtext)) // text (ip1:ip2-1)
    endif
    ip1 = ip2+2                                                            ! skip separator and begin of next word
    ip2 = ip1
  else
    ip2 = ip2 + 1
  end if
end do

newtext = newtext(:len_trim(newtext))  // text(ip1:)

end function prepare

!-----------------------------------
! Convert prepared text to CamelCase
!-----------------------------------
function toCamelCase (txt) result(newtext)
!
! 1st char is lowercase, all spaces removed and word beginnings upperCase
!
character (len=*), intent (in) :: txt
character (:), allocatable  :: text, newtext
integer :: ip, l
character :: beginword

newtext = ''
text = prepare (txt)

l = len_trim(text)
newtext = newtext(:len_trim(newtext)) // tolower (text(1:1))

ip = 2

do while (ip <= l)
  if (text(ip:ip) .eq. sep) then
    ip = ip + 1             ! skip the separator
    if (ip <l) then
      beginword = toUpper (text(ip:ip))
      newtext = newtext(:len_trim(newtext)) // beginword
      ip = ip + 1           ! skip the beginWord
    end if
  else
    newtext = newtext(:len_trim(newtext)) // text(ip:ip)
    ip = ip + 1
  end if
end do
end function toCamelCase

!------------------------------------
! Convert prepared text to snake_case
!------------------------------------
function toSnakeCase (txt) result (newtext)
!
character (len=*), intent (in)  :: txt
character (:), allocatable ::  text, newtext
integer :: ip, l
character :: beginword

newtext = ''

text = prepare (txt)
l = len_trim (text)
newtext = newtext(:len_trim(newtext)) // tolower (text(1:1))
ip = 2

do while (ip <= l)
  if (text(ip:ip) .eq. sep) then
    newtext = newtext(:len_trim(newtext))  // '_'    ! Replace sep by '_'
    ip = ip + 1
    if (ip <l) then
      beginword = toLower (text(ip:ip))       ! New word always starts in lowercase
      newtext = newtext(:len_trim(newtext))  // beginword
      ip = ip + 1           ! skip the beginWord
    end if
  else
    newtext = newtext(:len_trim(newtext))  // text(ip:ip)
    ip = ip + 1
  end if
end do
end function toSnakeCase

!----------------------------------------------------------------------------------
! get number of displayed characters of a string, which might differ from len(text)
!----------------------------------------------------------------------------------
integer function ulen(chars)
implicit none

  character(len=*), intent(in) :: chars
  integer :: i, j, bytes

  ulen = 0
  bytes= len(chars)
  if ( bytes == 0 ) then
    ulen = 0
    return
  end if
  i = 1
  do while ( i <= bytes )
    j = ulen_single(chars(i:i))
    i = i + j
    ulen = ulen + 1
  end do
end function
!------------------------------------------------------------
! look at single character and see how many bytes it occupies
!------------------------------------------------------------
function ulen_single(ch) result(retlen)
  implicit none
  character, intent(in) ::ch
  integer :: retlen, ich

  retlen=0
  ich = ichar(ch)

  if ( ich < int(Z'80') ) THEN
    retlen=1
  else if ( (ich > ( int(Z'C0') + 1)) .and. ( ich < int(Z'E0') )) THEN
    retlen=2
  else if ( ich < int(Z'F0') ) THEN
    retlen=3
  else if ( ich <= int(Z'F4') ) THEN
    retlen=4
  else
    retlen=1   !assume we process larger seqences, 1 by 1 bytes
  end if
end function


end program
