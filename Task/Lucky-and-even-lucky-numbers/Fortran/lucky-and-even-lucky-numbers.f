!
! Lucky and even lucky numbers
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
! but NOT VSI Fortran x86-64 V8.7-001 because that compiler does not accept
! character variables with allocatable lengths
! U.B., March 2026
!
program Lucky
  implicit none

  integer, parameter :: even=1, odd=0

  integer :: num_args, ii
  character(len=12), dimension(:), allocatable :: args

  integer:: j, k     ! thes values can be set in argument list
  logical :: OK       ! to indicate success of function getInt

  integer :: oddoreven =  odd ! this is the default unless evenlucky is selected by user

  num_args = command_argument_count()

  ! If no command line arguments have been given, just perform all test cases from the task description and bail out
  if (num_args .eq. 0) then
    call doTheTests ()
    stop
  endif

  ! Maybe someone wants to remove above test code to be executed in absence of command line arguments.
  ! So check again:
  if (num_args .lt. 1) then
    call printHelpandExit()
  else

    allocate(args(num_args))  ! omitted checking the return status of the allocation

    do ii = 1, num_args
      call get_command_argument(ii,args(ii))
    end do

    ! 1st argument is already checked to be present, and it is expected it is a positive integer
    OK = getInt (args(1), j)
    if (.not. OK) then            ! Invalid input?
      call printHelpandExit()
    endif

    ! if there is a second argument, it is either a comma, or a positive number, or a negative number
    if (num_args .gt. 1) then
      if (args(2) .ne. ',') then
        OK = getInt (args(2), k)
        if (.not. OK) then          ! invalid input
          call printHelpandExit()
        endif
      else
        ! args(2) is ',', so k is unused
        k = 0
      end if
    else
      k=0       ! THis is the default if no second argument is given.
    endif

    ! If there is a third argument, it can only be 'lucky' or 'evenlucky' (not case-sensitive)
    if (num_args .gt.2) then
      if (caseBlindEquals (args(3),'lucky')) then
        ! Nothing here, generate odd lucky numbers is the default
        oddoreven = odd     ! set again, just for clarity
      else if (caseBlindEquals (args(3),'evenlucky')) then
        oddoreven = even
      else
        call printHelpandExit()
      endif
    endif
  endif

  if (k .eq. 0) then    ! no upper limit: no range generate j'th odd or even lucky number
    call generate (jth=j, even1odd0=oddOrEven)
  else if (k .gt. 0) then
    call generate (rangefrom=j, rangeto=k, even1odd0 = oddOrEven)
  else if (k .lt. 0) then
      call generate (valfrom=j, valto=-k, even1odd0 = oddOrEven)
  endif

contains

  !==========================================================
  ! do the minimum requirements stated in the task escription
  !==========================================================
  subroutine doTheTests

  ! showing the first twenty lucky numbers
  call generate (rangefrom=1,rangeto=20, even1odd0 = odd)
  !showing the first twenty even lucky numbers
  call generate (rangefrom=1,rangeto=20, even1odd0 = even)
  !showing all lucky numbers between 6,000 and 6,100 (inclusive)
  call generate (valfrom=6000,valto=6100, even1odd0 = odd)
   !showing all even lucky numbers in the same range as above
  call generate (valfrom=6000,valto=6100, even1odd0 = even)
  !showing the 10,000th lucky number (extra credit)
  call generate (jth= 10000, even1odd0 = odd)
  !showing the 10,000th even lucky number (extra credit)
  call generate (jth= 10000, even1odd0 = even)

  end subroutine doTheTests


  ! ===============================================================================
  ! Generate even or odd lucky numbers and print them if their index or their value
  ! is within the specified range, or print one with a given index. On the OEIS
  ! pages a C++ program for this can be found. Here we have the Fortran translation
  ! of that code, with small adjustments to fulfill the particular requirements.
  ! ===============================================================================
  subroutine generate (rangefrom, rangeto, valfrom, valto, jth, even1odd0)

  implicit none
  integer,parameter :: longlong=8
  integer, intent(in), optional :: rangefrom, rangeto, valfrom, valto, jth, even1odd0

  integer :: local_rangefrom, local_rangeto, local_valfrom,local_valto, local_jth, local_even1odd0
  integer (kind=longlong), dimension(:), allocatable :: lucky
  integer(kind=longlong) :: elems, g, k, n, i

  ! Provide fefaults for optional arguments
  local_rangefrom=-1                            ! -1 indicates UNUSED
  local_rangeto=-1
  local_valfrom=-1
  local_valto=-1
  local_jth=-1
  local_even1odd0 = odd                         ! Odd is the default.

  if (present (even1odd0) )   local_even1odd0 = even1odd0

  if (present (jth)) then                       ! 1 selected index to display
    elems = jth                                 ! Generate up to this index
    local_jth = jth
    ! Print 1 line indicating what kind of output follows
    if (local_even1odd0 .eq. even) then
      write (*,'(//"The Even Lucky Number at index ", i0, " is:",/,"  Index   Number ", /, "  -----   ------"   )') &
         local_jth
    else
      write (*,'(//"The Lucky Number at index ", i0, " is:",/,"  Index   Number ", /, "  -----   ------"   )')  &
         local_jth
    endif

  else if (present (rangefrom) .and. present (rangeto)) then
    ! Index range
    local_rangefrom = min(rangefrom,rangeto)            ! Use MIN / MAX to allow wrong order for range limits
    local_rangeto = max(rangeto, rangefrom)
    elems = local_rangeto                               ! upper limit is number of elements
    if (local_even1odd0 .eq. even) then
      write (*,'(//"The Even Lucky Numbers with index in range ", i0, " ... ", i0, " are:",/,"  Index   Number ", /, "  -----   ------"   )') &
         local_rangefrom, local_rangeto
    else
      write (*,'(//"The Lucky Numbers with index in range ", i0, " ... ", i0, " are:",/,"  Index   Number ", /, "  -----   ------"   )')  &
         local_rangefrom, local_rangeto
    endif

  else if (present (valfrom) .and. present (valto)) then
    ! Value range
    local_valfrom = min(valfrom, valto)
    local_valto = max(valto,valfrom)

    elems = local_valto                   ! But end processing as soon as the entire range has been printed
    if (local_even1odd0 .eq. even) then
      write (*,'(//"The Even Lucky Numbers in range ", i0, " ... ", i0, " are:",/,"  Index   Number ", /, "  -----   ------"   )') &
        local_valfrom, local_valto
    else
      write (*,'(//"The Lucky Numbers in range ", i0, " ... ", i0, " are:",/,"  Index   Number ", /, "  -----   ------"   )')  &
        local_valfrom, local_valto
    endif
  endif


  ! Create a vector for our sieve
  allocate (lucky(0:elems))

  ! Set and print the first two elements explicitly
  ! Indexing from 0 simplifies the computation
  if (elems .ge.1) then
    lucky(0) = 1+local_even1odd0
    if (local_valfrom .le. lucky(0) .and. local_valto .ge.lucky(0)       &
   .or. local_rangefrom .le. 1 .and. local_rangeto .ge. 1  &
   .or. local_jth .eq. 1)  then
      write (*,'(I7, 3x, i0)') 1, lucky(0)
    end if
  endif
  if (elems .ge. 2) then
    lucky(1) = 3+local_even1odd0
    if (local_valfrom .le. lucky(1) .and. local_valto .ge.lucky(1)       &
   .or. local_rangefrom .le. 2 .and. local_rangeto .ge. 2  &
   .or. local_jth .eq. 2)  then
      write (*,'(I7, 3x, i0)') 2, lucky(1)
    end if
  endif

  ! g is the largest index with lucky[g] <= n+1
  g = 0

  ! Compute the nth lucky number for 2 <= n <= elems
  !for (unsigned n = 2; n < elems; n++)
  do n=2, elems
    ! Update g to largest index with lucky[g] <= n+1
    if (lucky(g+1) .ge. n+1) g = g+1

    ! Now we are going to trace the position k of the nth
    ! lucky number backwards through the sieving process.
    ! k is the nth lucky number, so it is at position n
    ! after all the sieves.
    k = n

    ! If lucky[i] > n+1, the sieve on lucky[i] does not alter
    ! the position of the nth lucky number, that is, does not
    ! alter k. So we need to run backwards through the sieves
    ! for which lucky[i] <= n+1. The last such sieve is the
    ! sieve for lucky[g], by definition of g.

    ! So, we run backwards through the sieves for lucky[g]
    ! down to the sieve for lucky[1] = 3.
!    for (unsigned i = g; i >= 1; i--)
    do i=g,1,-1
      ! Here k is the position of the nth lucky number
      ! after the sieve on lucky[i]. Adjust the position
      ! prior to the sieve on lucky[i].
      k = k*lucky(i)/(lucky(i)-1)
    enddo

    ! Here k is the position of the nth lucky number prior to
    ! sieve on 3, that is, after the sieve on 2. Adjust the
    ! position prior to the sieve on 2.
    k = 2*k+local_even1odd0

    ! Here k is the position of the nth lucky number prior to
    ! the sieve on 2, that is, within the natural numbers
    ! (1, 2, 3, ...) indexed from 0. So the nth lucky number is
    lucky(n) = k+1

    ! Adjust n for 1-indexing and print our new value
    if  (local_valfrom .le. lucky(n) .and. local_valto .ge.lucky(n)    &
    .or. local_rangefrom .le. n+1 .and. local_rangeto .ge. n+1         &
    .or. local_jth .eq. n+1) then
      write (*,'(I7, 3x, i0)') n+1, lucky(n)
      if (local_valto .eq. lucky(n) .or. local_rangeto .eq. n+1 .or. local_jth .eq. n+1) return
    end if
  end do

  deallocate (lucky)
  ! And we are done
  end subroutine generate




  ! ====================================================================
  ! Case blind string comparison, returns .true. if a and b are the same
  ! ====================================================================
  function caseBlindEquals (a, b) result (retv)
  character (len=*), intent(in) :: a, b
  logical :: retv

  character (len=:), allocatable :: caseBlind_a, caseBlind_b

  caseBlind_a = A
  caseBlind_b = B

  ! Convert to lower case and compare the results.
  call lowerCase (caseBlind_a)
  call lowerCase (caseBlind_b)

  retv = (caseBlind_a .eq. caseBlind_b)
  end function caseBlindEquals


  ! =====================================================================
  ! Convert a string c to lower case. Do not rely on ASCII representation
  ! =====================================================================
  subroutine lowerCase (c)
  character (len=*), intent(inout) :: c
  character (len=26), parameter :: alphaUPPER = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', &
                                   ALPHAlower = 'abcdefghijklmnopqrstuvwxyz'

  integer :: ii, idx

  do ii=1, len(c)
    idx = index (alphaUPPER, c(ii:ii))
    if (idx .gt. 0) c(ii:ii) = ALPHAlower(idx:idx)
  enddo

  end subroutine lowerCase


  ! =================================================================================
  ! Try to convert a string (a command line argument) to an Integer value.
  ! if this is not possible (e.g. if string is not a numeric, return value is .false.
  ! =================================================================================
  function getInt (A, i) result (OK)
  character (len=*), intent(in)   :: a
  integer, intent(out)  :: i
  logical :: OK
  integer :: ios

  read (a,'(i10)', iostat=ios)  i

  OK = (ios .eq. 0)       ! 0 only if read OK. Any value of ios other than 0 indicates error

  end function getInt


  ! =========================================================
  ! Write out explanatory help text, in case if invalid input
  ! =========================================================
  subroutine printHelpandExit ()

    write (*, '(A)')   "./lucky j [k | , ] [lucky | evenLucky]"
    write (*, *)   ! empty line
    write (*, '(A)')   "       argument(s)  |  what is displayed"
    write (*, '(A)')   "=============================================="
    write (*, '(A)')   "j                   |  jth lucky number"
    write (*, '(A)')   "j  , lucky          |  jth lucky number"
    write (*, '(A)')   "j  , evenLucky      |  jth even lucky number"
    write (*, '(A)')   "j  k                |  jth through kth (inclusive) lucky numbers"
    write (*, '(A)')   "j  k  lucky         |  jth through kth (inclusive) lucky numbers"
    write (*, '(A)')   "j  k  evenLucky     |  jth through kth (inclusive) even lucky numbers"
    write (*, '(A)')   "j  -k               |  all lucky numbers in the range [j, k]"
    write (*, '(A)')   "j  -k  lucky        |  all lucky numbers in the range [j, k]"
    write (*, '(A)')   "j  -k  evenLucky    |  all even lucky numbers in the range [j, k]"

    !*******************
    stop    ! ERROR EXIT
    !*******************
  end subroutine printHelpandExit

end program Lucky
