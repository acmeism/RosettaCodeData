!
! Punched Cards
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!

program PunchedCards
implicit none

character (len=80), dimension(0:12) :: Card  ! to be set and printed by 'contained' functions/subroutines

character(len=80) :: cardText
character (len=80), dimension(3) :: cardDeckText
! the ' is duplicated, the " is not.

cardText = '&-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@''="[.<(+|]$*);^\,%_>?'
call punchCard (cardText)

cardDeckText (1) = "Program HelloWorld"
cardDeckText (2) = "Write (*,'(A)' )'Hello world!'"
cardDeckText (3) = "End program HelloWorld"
call PunchCard (cardDeckText(1))
call PunchCard (cardDeckText(2))
call PunchCard (cardDeckText(3))

contains

subroutine PunchCard (Text)
character (len=*), intent(in) :: Text
integer :: l, i, j, code

! Before printing the encoded card, print the text line,
! just as a real punched card, which had the clear text near the topmost edge.
write (*, '(A)')   Text
Card = ' '    ! All blank
l = len_trim (Text)

! "Punch" column 'i' with the code as selected from the CASE switch
do i=1, l
  code = ichar (Text(i:i))
  select case (Text(i:i))

     Case ('&')
            call PunchChar(i, 12)

        Case ('A' : 'I')
            call PunchChar(i, 12)
            call PunchChar(i, code - ichar('A') + 1)

        Case ('[')
            call PunchChar(i, 2)
            call PunchChar(i, 8)
            call PunchChar(i, 12)

        Case ('.')
            call PunchChar(i, 3)
            call PunchChar(i, 8)
            call PunchChar(i, 12)

        Case ('<')
            call PunchChar(i, 4)
            call PunchChar(i, 8)
            call PunchChar(i, 12)

        Case ('(')
            call PunchChar(i, 5)
            call PunchChar(i, 8)
            call PunchChar(i, 12)

        Case ('+')
            call PunchChar(i, 6)
            call PunchChar(i, 8)
            call PunchChar(i, 12)

        Case ('!')
            call PunchChar(i, 7)
            call PunchChar(i, 8)
            call PunchChar(i, 12)

        Case ('-')
            call PunchChar(i, 11)

        Case ('J' : 'R')
            call PunchChar(i, 11)
            call PunchChar(i, code - ichar('J') + 1)

        Case (']')
            call PunchChar(i, 2)
            call PunchChar(i, 8)
            call PunchChar(i, 11)

        Case ('$')
            call PunchChar(i, 3)
            call PunchChar(i, 8)
            call PunchChar(i, 11)

        Case ('*')
            call PunchChar(i, 4)
            call PunchChar(i, 8)
            call PunchChar(i, 11)

        Case (')')
            call PunchChar(i, 5)
            call PunchChar(i, 8)
            call PunchChar(i, 11)

        Case (';')
            call PunchChar(i, 6)
            call PunchChar(i, 8)
            call PunchChar(i, 11)

        Case ('^')
            call PunchChar(i, 7)
            call PunchChar(i, 8)
            call PunchChar(i, 11)

        Case ('/')
            call PunchChar(i, 0)
            call PunchChar(i, 1)

        Case ('S' : 'Z')
            call PunchChar(i, 0)
            call PunchChar(i, code - ichar('S') + 2)

        Case ('\')
            call PunchChar(i, 2)
            call PunchChar(i, 8)
            call PunchChar(i, 0)

        Case (',')
            call PunchChar(i, 3)
            call PunchChar(i, 8)
            call PunchChar(i, 0)

        Case ('%')
            call PunchChar(i, 4)
            call PunchChar(i, 8)
            call PunchChar(i, 0)

        Case ('_')
            call PunchChar(i, 5)
            call PunchChar(i, 8)
            call PunchChar(i, 0)

        Case ('>')
            call PunchChar(i, 6)
            call PunchChar(i, 8)
            call PunchChar(i, 0)

        Case ('?')
            call PunchChar(i, 7)
            call PunchChar(i, 8)
            call PunchChar(i, 0)

        Case (' ')
            ! do nothing

        Case ('0' : '9')
            call PunchChar(i, code - ichar('0'))

        Case ('`')
            call PunchChar(i, 1)
            call PunchChar(i, 8)

        Case (':')
            call PunchChar(i, 2)
            call PunchChar(i, 8)

        Case ('#')
            call PunchChar(i, 3)
            call PunchChar(i, 8)

        Case ('@')
            call PunchChar(i, 4)
            call PunchChar(i, 8)

        Case ( '''' )
            call PunchChar(i, 5)
            call PunchChar(i, 8)

        Case ('=')
            call PunchChar(i, 6)
            call PunchChar(i, 8)

        Case ('"')
            call PunchChar(i, 7)
            call PunchChar(i, 8)

        Case ('a' : 'i')
            call PunchChar(i, 12)
            call PunchChar(i, 0)
            call PunchChar(i, code - ichar('a') + 1)

        Case ('|')
            call PunchChar(i, 12)
            call PunchChar(i, 11)

        Case ('j' : 'r')
            call PunchChar(i, 12)
            call PunchChar(i, 11)
            call PunchChar(i, code - ichar('j') + 1)

        Case ('s' : 'z')
            call PunchChar(i, 11)
            call PunchChar(i, 0)
            call PunchChar(i, code - ichar('s') + 2)

        Case default
            Print *, 'Invalid code: ', code



  end select

end do

! Print the card, including top and bottom, left and right edges as lines
! The order of the rows is line 12, then 11, then 0...11
write (*,'(" ", 80("_"), ".")')
! Line 12
  write (*,'("/")', advance='no')
  do j=1,80
    write (*,'(A)', advance='no')   Card(12) (j:j)
  end do
  write (*,'("|")')
! Line 11
  write (*,'("|")', advance='no')
  do j=1,80
    write (*,'(A)', advance='no')   Card(11) (j:j)
  end do
  write (*,'("|")')

do i=0, 10
  write (*,'("|")', advance='no')
  do j=1,80
    write (*,'(A)', advance='no')   Card(i) (j:j)
  end do
  write (*,'("|")')
enddo
write (*,'("|", 80("_"), "|")')

end subroutine PunchCard

subroutine PunchChar (col,row)
integer, intent(in) ::  col, row

Card (row)(col:col) = 'X'           ! Hole here

end subroutine PunchChar

end program PunchedCards
