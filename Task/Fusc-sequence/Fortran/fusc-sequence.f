!
! Fusc sequence
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., September 2025

program FuscNumbers

  implicit none

  integer, parameter :: kInt = 4
  integer, parameter :: maxdigs = 6
  integer, parameter :: strLen = 20

  integer (kind=kInt), allocatable   :: fuscMem(:)

  integer :: capacity, content                              ! usage of above container

  integer (kind=kInt) :: w,c,t
  integer (kind=kINt) :: i, f
  integer :: d=0, n=61, digs=1

  character (len=strLen)  :: sNum(2)      ! for formatted output of integer numbers

  content = 0
  capacity = 1024
  call resize (fuscMem, capacity)

  call push (0)
  call push (1)

  w = -1
  c = 0
  n = 61
  write ( *, '("First " , i0, " numbers in the fusc sequence:" )')  n

  i = 0
  do while (i .lt. 61)
    f = fusc(i)
    if (mod (i, 20) .ne. 0) then
      write (*, '(i2, x)', advance='no' ) f
    else
      write (*, '(i2,x)') f
    endif
    i = i + 1
  end do

  write (*, '(/"Fusc numbers with more digits than any previous (1 to 6 digits):")')
  write (*, '( "                Index      Value")')
  i = 0
  do while (digs <= maxdigs)
    f = fusc (i)
    if (f .ge. d) then
      ! show all numbers with commas   (if appropriate).
      snum(1) = GroupedDigits(i, 10)
      snum(2) = GroupedDigits(f,10)
      if (digs .gt.1) then
        write (*,'(i2, " digits: ", A10,x,A )' )  digs, snum(1), snum(2)
      else
        write (*,'(i2, " digit : ", A10,x,A )' )  digs, snum(1), snum(2)
      endif
      if (d .eq. 0) then
        d = 10
      else
        d = d * 10
      endif
      digs = digs + 1
      if (digs .gt. 6) exit
    end if
    i = i + 1
  end do


  contains

  function fusc (n) result (ret)
  integer (kind=kint), intent(in) :: n
  integer (kind=kInt)   ret


  if (n .lt. content)  then
    ret = fuscMem (1+n)
  else
    if (iand (n,1_kint) .eq. 0)   then            ! Even n has bit 0 = zero
      ret = fuscMem(1+n/2)
      call push (ret)                             ! Store for future use.
    else                                          ! Else its odd.
      ret = fuscMem(1+(n-1)/2) + fuscMem(1+(n+2)/2)
      call push (ret)
    end if
  end if

  end function fusc

  ! ---------------------
  ! memoize another value
  ! ---------------------
  subroutine push (k)
  integer (kind=kint), intent (in) :: k

  content = content+1

  ! If we would exceed capacity of array 'Words', we need to increment capacity
  if (content .gt. capacity) then
    capacity = 2*capacity
    call resize (fuscMem, capacity)
  end if
  fuscMem(content) = k
  end subroutine push


  ! ----------------------------------------------
  ! Increase allocated size of dynamic array 'var'
  ! ----------------------------------------------
  subroutine resize(var, newSize)
  integer (kind=kint), allocatable, intent(inout) :: var(:)     ! The array to be increased
  integer, intent(in)                             :: newSize    ! The new size of var
  integer (kind=kint), allocatable                :: tmp(:)     ! Temporary storage
  integer                                         :: oldSize    ! Current array size
  integer                                         :: ii         ! Loop index

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


! ----------------------------------------------------------------
  ! Fortran does not have a way to use locales for output.
  ! Manual insert of separating commas such as 1,345,678 for 1345678
  ! ----------------------------------------------------------------
  function GroupedDigits (n, width) result (outStr)
  integer(kind=kint), intent (in) :: n
  integer :: width
  character (len=width) :: outStr
  character (len=2*strLen) :: workStr
  integer :: ii, jj, cnt, trueLen


  ! Write n into a string, then copy the digits to a second string,
  ! inserting separater after every 3 digits.
  write (workStr, '(i0)') n
  ! Adjust left, then cutoff trailing blanks
  workstr = adjustl (workstr)
  trueLen = len_trim (workStr)

  outStr = ' '
  jj = width
  cnt = 0
  do ii=trueLen, 1, -1                  ! Copy backwards for correct grouping.
    outStr (jj:jj) = workStr (ii:ii)
    jj = jj -1
    cnt = cnt + 1
    ! Insert comma after 3 digits, but only if more digits follow.
    if (mod (cnt, 3) .eq. 0 .and. ii .gt. 1 .and. workStr(ii-1:ii-1) .ne. ' ') then
      outStr (jj:jj) = ','
      jj = jj - 1
    endif
  end do

  end function GroupedDigits

 end program  FuscNumbers
