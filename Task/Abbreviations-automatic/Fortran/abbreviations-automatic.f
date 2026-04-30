!
! Abbreviations, automatic
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! U.B., December 2025
!==============================================================================

program AbbrAuto
  integer, parameter :: longestLine = 210    ! Longest input line
  integer, parameter :: LongestDay = 30      ! Longest length of 1 day name
  character (len=longestLine) :: Line
  character (len=LongestDay)  :: Days(7)      ! 1 week

  integer :: l, io_stat
  logical :: OK

  open (unit=10, file = 'days_of_week.txt', status='old', action='read', iostat=io_stat)
  if (io_stat /= 0) then
     print *, "Error opening file"
     stop
  end if


  do                                        ! Read all lines
    read (10, '(A)', iostat=io_stat) Line
    if (io_stat <0) exit                    ! Normal: EOF on input
    if (io_stat >0) then                    ! Not Normal: Read error
      print *, "Read error"                 ! has never been observed during testing.
      exit
    end if
    call separateDays (Line, Days, OK)
    if (OK) then                             ! 7 week days' name found
      print '(I2, X, A)' , smallestAbreviation (Days), Line (:len_trim(Line))
    else
      print *                                 ! Null string for empty or invalid line
    endif

  end do    ! Read all lines

  contains


  ! =========================================================================================
  ! Argument argLine contains space-separated list of (expected) 7 names of week days.
  ! Separate day names into array argDays, OK is .false. if number of days is not exactly 7.
  ! =========================================================================================
  subroutine separateDays (argLine, argDays, OK)

  character (len=longestLine), intent(in) :: argLine
  character (len=LongestDay) , intent(out) :: argDays(7)      ! 1 week
  logical, intent(out) :: OK
  integer :: ip1, ip2, nDays            ! 2 Pointers into line, number of day names detected
  integer :: l

  ip1 = 1
  nDays = 0

  l = len_trim (argLine)
  do while (ip1 .le. l)                                     ! Loop untill entire line processed.
    do while (ip1 .le. l .and. argLine (ip1:ip1) .eq. ' ')  ! Skip space(s)
      ip1 = ip1 + 1
    end do
    if (ip1 .le. l) then                                    ! still inside Line?
      ip2 = ip1
      do while (ip2 .le. l .and. argLine (ip2:ip2) .ne. ' ')  ! Find end of current word
        ip2 = ip2 + 1
      end do

      ! Here found space or end of line: Word is complete
        if (ip2 .gt. l) ip2 = l                               ! End reached
        if (argLine (ip2:ip2) .eq. ' ') ip2 = ip2 - 1         ! Space found
        if (ip2 .gt. ip1) then                                ! day name has at least 2 letters
          nDays = nDays + 1
          argDays (nDays) = ' '
          argDays (nDays) = argLine (ip1:ip2)
        endif                               !
      ip1 = ip2 + 1         ! Prepare for next day search: set behind current word
    endif
  end do
  OK = (nDays .eq. 7)   ! Result is OK only if number of days is 7
  end subroutine separateDays

  ! =============================================================================
  ! Find length of smallest abbreviation of 7 day names so that abbreviated name
  ! is still unique.
  ! =============================================================================
  function smallestAbreviation (argDays)   result (nUniq)
  character (len=LongestDay) , intent(in) :: argDays(7)      ! 1 week
  integer :: nUniq
  integer :: ii, jj
  logical :: done
  nUniq = 1
  done = .false.
  do while (.not. done)
    done = .true.
    daysLoop: do ii=1, 6
      do jj=ii+1,7
        if (argDays (ii)(:nUniq) .eq. argDays(jj)(:nUniq)) then
          ! nUniq is too small for useful abbreviation of week days' name
          nUniq = nUniq + 1
          done = .false.
          exit daysLoop             ! go and try tith next larger nUniq
        end if
      end do
    end do daysLoop
    ! here: done is .true. if no two day names are identical in first 'nUuniq' characters
    ! otherwise still the abbreviation is still too short
  end do
  end function smallestAbreviation


end program AbbrAuto
