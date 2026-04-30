!
! Abbreviations, simple
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
! VSI Fortran does not/not yet compile this code.
! U.B., December 2025
!==============================================================================
program AbbrSimple

  implicit none

  integer, parameter  :: lenCmd = 10
  character (len=*), parameter  :: cmdTable =  &
   'add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 '&
   'compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate '&
   '3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 '&
   'forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load '&
   'locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 '&
   'msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 '&
   'refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left '&
   '2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 '


  character (len=*), parameter  :: userCmds  = &
   ' riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin'

  character (len=*), parameter :: invalid = '*error*'

  character (len=len(cmdTable))   :: upcaseCmdTable
  character (len=len(userCmds))   :: upcaseUserCmds
  character (len=lenCmd) :: parsedCmd
  character (len=lenCmd), allocatable :: allCmd (:), allUpcaseCmd(:)
  integer, allocatable  :: minLength (:)

  character (len=lenCmd)  inputCmd(10), upcaseInputCmd(10)    ! 10 counted manually.

  integer :: ip1, ip2
  integer :: ii, l, la, nSpaces

  ! Prepare command table to UPPER CASE for case-blind compare
  ! count spaces so we get an idea how many commands there are in total.

  nSpaces = 0
  do ii=1, len(cmdTable)
    upcaseCmdTable (ii:ii) = toupper (cmdTable (ii:ii))
    if (upcaseCmdTable (ii:ii) .eq. ' ') nSpaces = nSpaces + 1
  end do

  ! Also, have all user commands in UPCASE
  do ii=1, len(userCmds)
    upcaseUserCmds (ii:ii) = toupper (userCmds (ii:ii))
  end do

  ! make space for the array with all commands bioth upper and lower case.
  allocate (character(len=lenCmd) :: allCmd (nSpaces+1))           ! might be more than needed bc superfluous spaces
  allocate (character(len=lenCmd) :: allUpcaseCmd(nSpaces+1))
  allocate (integer :: minLength (nSpaces+1))

  ! Prepare lists of allowed commands and input commands
  call tokenize (cmdTable, upcaseCmdTable, allCmd,allUpcaseCmd, minLength)
  call tokenize (userCmds, upcaseUserCmds, inputCmd, upcaseInputCmd) ! 5th arg is optional

  ! As first output line, print user input
  write (*, '("Input:  ", 10(A10,x))') (inputCmd(ip1), ip1=1, size(inputCmd))
  write (*, '("Parsed: ")', advance='no')
  ! Parse all user input commands
  do ip1 = 1, size(inputCmd)
    l = len_trim (inputCmd(ip1))
    parsedCmd = invalid
    do ip2 = 1, size(allCmd)
      la =len_trim(allCmd(ip2))
      if (la .ge. l) then           ! input is possible abbreviation of this command
        ! Case blind comparison
        if (allUpcaseCmd(ip2)(:l) .eq. upcaseInputCmd (ip1) (:l))  then
          ! at least this input cmd is a short form of this full command.
          ! But is it valid?
          if (minLength(ip2) .gt. l) then
            cycle     ! input is shorter than required minimum length,  try next command
          endif
        else
          cycle       ! input does not match command
        endif
        ! Here we know that input an abbreviation of command,
        ! and that it is not too short
        parsedCmd = allUpcaseCmd (ip2)  ! We have a result
        exit                            ! no need to check input against following commands
      else
        ! input is longer than this command, nothing to do.
      end if
    end do
    ! here we found the valid command, or the parsed value is still
    write (*, '(A10,X)', advance='no')  parsedCmd
  end do
  write (*,*)         ! Terminate output line.

contains

  ! ======================================================================================
  ! Divide a string of words separated by blanks into an array of the words without blanks
  ! ======================================================================================
  subroutine tokenize (tokenString, upCaseString, retList, upcaseRetList, minLength  )

  character (len=*), intent(in) :: tokenString, upcaseString            ! input "as is" and "upcase"
  character (len=lencmd), intent(out) :: retList(*), upcaseRetList(*)   ! Result "as is" and "Upcase"
  integer, intent(out), optional :: minLength(*)                        ! Minimum lengths of commands
  integer :: ip1, ip2                                                   ! pointers into tokenString
  integer :: nTokens                                                    ! Counter forisolated words
  integer :: lstr                                                       ! Length of the tokenString

  ip1 = 1
  nTokens = 0
  lstr = len_trim (tokenString)
  ! Expect keyword first, then an optional number.
   do while (ip1 .le. lstr)
    ! First scan for a command
    do while (ip1 .le. lstr .and. tokenString (ip1:ip1) .eq. ' ')  ! Skip space(s)
      ip1 = ip1 + 1
    end do

    if (ip1 .le. lstr) then                                    ! still inside Line?
      ip2 = ip1
      ! First expect keyword
      do while (ip2 .le. lstr .and. tokenString (ip2:ip2) .ne. ' ')  ! Find end of current word
        ip2 = ip2 + 1
      end do
      ip2 = ip2 - 1     ! set to the true end of the new command, not one behind the next keyword
      nTokens = nTokens + 1

      retList (nTokens) = tokenString (ip1:ip2)
      upcaseRetList (nTokens) = upcaseString (ip1:ip2)

      ! Now go look for the number
      ip1 = ip2 + 1                   ! prepare to find start of next text (numeric or not)
      if (ip1 .le. lstr) then         ! Still not past the end of tokenString?
        do while (ip1 .le. lstr .and. tokenString (ip1:ip1) .eq. ' ')  ! Skip space(s)
          ip1 = ip1 + 1
        end do
        if (isDigit (tokenString (ip1:ip1))) then
          if (present (minLength)) then
            ip2 = ip1
            read (tokenString (ip1:), *)  minLength (nTokens)
            do while (ip2 .le. lstr .and. isDigit (tokenString(ip2:ip2)) )  ! Find end of current Number
              ip2 = ip2 + 1
            end do
            ip1 = ip2         ! prepare for next text search. ip2 is already behind the number.
          endif
        endif
      endif
    endif
  end do

  end subroutine tokenize

  ! =========================================================
  ! Convert a character c to UPPER CASE, if its in lower case.
  ! =========================================================

  function toupper (c) result (U)
  character, intent(in) :: c        ! input
  character :: U                    ! output
  integer :: ix                     ! Helper: index of c in alphabet

  Character(26), Parameter :: cap = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  Character(26), Parameter :: low = 'abcdefghijklmnopqrstuvwxyz'

  ix = index (low, c)      ! find c in lower case alphabet
  if (ix .gt. 0) then      ! c found: it is in lower case
    U = cap (ix:ix)        !    ...and needs conversion
  else                     ! c not found, so is already in upper case,
    U = c                  !     ...or it is not a letter. Just copy to result.
  endif
  end function toupper


  ! ==========================================================
  ! Returns .true. if input character c is in interval [0...9]
  ! ==========================================================
  function isDigit (c) result (YN)
  character, intent(in) :: c
  logical :: YN
  YN = (index ('0123456789', c) .ne. 0)
  end function isDigit

end program AbbrSimple
