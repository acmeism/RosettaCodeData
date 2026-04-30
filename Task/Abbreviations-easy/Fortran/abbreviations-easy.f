!
! Abbreviations, easy
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! U.B., December 2025
!==============================================================================
program AbbrEasy

  implicit none

  integer, parameter  :: lenCmd = 10
  character (len=*), parameter  :: cmdTable =  &
    'Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy ' // &
    'COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find ' // &
    'NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput ' // &
    'Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO ' // &
    'MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT ' // &
    'READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT ' // &
    'RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up'

  character (len=*), parameter  :: userCmds  = &
   ' riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin'

  character (len=*), parameter :: invalid = '*error*'

  character (len=len(cmdTable))   :: upcaseCmdTable
  character (len=len(userCmds))   :: upcaseUserCmds
  character (len=lenCmd) :: parsedCmd
  character (len=lenCmd), allocatable :: allCmd (:), allUpcaseCmd(:)
  character (len=lenCmd)  inputCmd(10), upcaseInputCmd(10)    ! 10 counted manually.

  integer :: ip1, ip2
  integer :: ii, l, la, nSpaces, nUP

  ! Have a second command table, all in UPCASE , and count spaces so we get an idea how many
  ! commands there are in total.
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
  allocate (allCmd (nSpaces+1))           ! might be more than needed bc superfluous spaces
  allocate (allUpcaseCmd (nSpaces+1))

  ! Prepare lists of allowed commands and input commands
  call tokenize (cmdTable, upcaseCmdTable, allCmd,allUpcaseCmd)
  call tokenize (userCmds, upcaseUserCmds, inputCmd, upcaseInputCmd)

  ! As first output line, print user input
  write (*, '(10(A10,x))') (inputCmd(ip1), ip1=1, size(inputCmd))
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
          NUP = 0                   ! Count number of starting UPCASE letters of command
          do ii=1, la
            if (allCmd (ip2)(ii:ii) .eq. allUpcaseCmd (ip2)(ii:ii)) then
              NUP = NUP + 1
            else
              exit                  ! found number of upcase characters, quit search.
            end if
          end do
          if (NUP .gt. l) then
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
  subroutine tokenize (tokenString, upCaseString, retList, upcaseRetList  )

  character (len=*), intent(in) :: tokenString, upcaseString  ! input "as is" and "upcase"
  character (len=lencmd), intent(inout) :: retList(*), upcaseRetList(*)  ! Result "as is" and "Upcase"
  integer :: ip1, ip2
  integer :: nTokens
  ip1 = 1
  nTokens = 0

  ! Divide single string to a list of words without spaces.
  l = len_trim (tokenString)
  do while (ip1 .le. l)
    do while (ip1 .le. l .and. tokenString (ip1:ip1) .eq. ' ')  ! Skip space(s)
      ip1 = ip1 + 1
    end do
    if (ip1 .le. l) then                                    ! still inside Line?
      ip2 = ip1
      do while (ip2 .le. l .and. tokenString (ip2:ip2) .ne. ' ')  ! Find end of current word
        ip2 = ip2 + 1
      end do
      if (ip2 .gt. l) ip2 = l                               ! End reached
      nTokens = nTokens + 1
!      print *, 'Command = ', tokenString (ip1:ip2)
      retList (nTokens) = tokenString (ip1:ip2)
      upcaseRetList (nTokens) = upcaseString (ip1:ip2)
      ip1 = ip2 + 1
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
end program AbbrEasy
