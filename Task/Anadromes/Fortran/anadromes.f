!
! Anadromes
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., September 2025

program Anadromes

  implicit none

  integer, parameter :: longestWord = 50                    ! is long enough for words.txt (45)

  character(len=longestWord) :: word                        ! 1 word to read
  character(len=longestWord), allocatable  :: Words(:)      ! the entire collection of all words
  integer :: capacity, content                              ! usage of above container

  integer :: l, io_stat, ii

  content = 0

  ! Begin with moderate words array size
  capacity = 1024
  call resize (Words, capacity)

  ! going to read all words from unixdict.txt
  open(unit=10, file='words.txt', status='old', action='read', iostat=io_stat)
  if (io_stat .ne. 0) then
     print *, "Error opening file"                  ! ERROR: would be useless to try reading words.
     stop
  end if

  do    ! read all words, until ERROR or EOF
    read (10,'(A)', iostat=io_stat)   word
    if (io_stat < 0) exit                          ! EOF: Normal end of this loop
    if (io_stat > 0) then
      print *, "Read error"                       ! ERROR (unexpected): would be useless to proceed
      exit
    end if

    ! Consider only words longer than 6 characters, skip shorter words.
    l = len_trim (word)                             ! use this instead of Q format
    if (l .gt. 6)  call addWord ()

  end do

  ! For correct and efficient binary search, the word list must be sorted
  call quicksort_strings (words, 1, content)

  do ii=1,content
    call checkWord (ii)     ! Prints a pair if an anadrome is found
  end do

  close(10)

  contains



  ! ------------------------------------
  ! add a new word to the list of words.
  ! ------------------------------------

  subroutine addWord()
  ! No local variables here. Just working on Main program's variables.

  content = content+1

  ! If we would exceed capacity of array 'Words', we need to increment capacity
  if (content .gt. capacity) then
    capacity = 2*capacity
    call resize (Words, capacity)
  end if

  Words(content) = word

! for case insensitivity, convert uppercase letters to lowercase
!  do ip=1,l
!    if (word(ip:ip) .ge. 'A' .and. word(ip:ip) .le. 'Z')    &
!      Words(content)(ip:ip) = char (ichar( Words(content)(ip:ip) ) - ichar('A') + ichar('a'))
!  enddo

  end subroutine addWord

  ! ----------------------------------------------------------------
  ! See if a word is also in word list when its letters are reversed
  ! ----------------------------------------------------------------
  subroutine checkWord (iw)

  integer, intent(in)  :: iw
  character (len=longestWord) :: revWord
  integer :: ip

  revWord = reversed (iw)
  ip = find (revword(:l) )

  if (ip .ne. 0 .and. words(iw) .lt. revword)  &
     print '(A9, " <--> ", A)' ,  &                  ! right-justified <-> left justified
       words(iw)(:len_trim(words(iw))) ,revWord(:len_trim(words(iw)))

  end subroutine checkWord

  ! -----------------------------------------------
  ! construct word in reversed order of its letters
  ! -----------------------------------------------
  function reversed (iw) result (r)

  integer, intent(in) :: iw
  character (len=longestWord) :: r

  integer:: l, ii

  l = len_trim (words(iw))
  r = ' '
  do ii = l, 1, -1
    r (1-ii+l:1-ii+l) = words(iw)(ii:ii)
  enddo
  end function reversed

  ! ----------------------------------------------
  ! Increase allocated size of string array 'var'
  ! ----------------------------------------------
  subroutine resize(var, newSize)
  character (len=longestWord), allocatable, intent(inout) :: var(:)   ! The array to be increased
  integer, intent(in)                             :: newSize          ! The new size of var
  character (len=longestWord), allocatable                :: tmp(:)   ! Temporary storage
  integer                                         :: oldSize          ! Current array size
  integer                                         :: ii               ! Loop index

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
    do ii=oldSize+1, newSize
      var (ii)(1:) = ' '
    end do
  end if
end subroutine resize

!------------------------------------------------------------
! Find a word in a list of possible keywords.
! Returns index of the word in that array, or 0 if not found.
! Binary search, array must be sorted.
!------------------------------------------------------------
function find (needle) result(index)
  character (len=longestWord) , intent(in)  :: needle
  integer    :: Index

  integer :: left, right, mid, wordlen
  integer :: comparison

  left = 1
  right = content
  index = 0               ! will signal 'not found'
  wordlen = len_trim(needle)
  mid = left + (left-right)/2

  do while (left <= right)
    mid = left + (right - left) / 2
    if (Words (mid)  .eq. needle ) then
                index = mid
                return
    else if (Words (mid) .lt. needle) then
      ! index of needle is between mid+1 and right.
      left = mid + 1
    else
      ! index of needle is between left and mid-1
      right = mid  - 1
    end if
  end do
end function find

recursive subroutine quicksort_strings(arr, low, high)

  character(len=*), dimension(:), intent(inout) :: arr
  integer, intent(in) :: low, high
  integer :: pivot_index
  integer :: i, j, mid
  character(len=len(arr(1))) :: pivot, temp

  if (low < high) then
    ! The word list is already "almost sorted", so use midlle word as pivot.
    mid = low + (high-low) / 2
    pivot = arr(mid)

    !Move pivot to the end
    temp = arr(mid)
    arr(mid) = arr(high)
    arr(high)=temp

    i = low - 1

    do j = low, high - 1
      if (arr(j) <= pivot) then
        i = i + 1
        temp = arr(i)
        arr(i) = arr(j)
        arr(j) = temp
      end if
    end do

    temp = arr(i+1)
    arr(i+1) = arr(high)
    arr(high) = temp
    pivot_index = i + 1

    call quicksort_strings(arr, low, pivot_index - 1)
    call quicksort_strings(arr, pivot_index + 1, high)
  end if
end subroutine quicksort_strings

end program Anadromes

