!
!Isograms and heterograms
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., January 2026
!==============================================================================

program Isograms
  implicit none

  integer, parameter :: longestWord = 50                    ! is long enough for unixdict

  type ::t_isogram
    character(len=longestWord) :: word
    integer ::   wordLength
    integer ::isoLength
  end type

  type ::t_heterogram
    character(len=longestWord) :: word
    integer ::   wordLength
  end type

  integer, parameter :: nIsograms=100       ! Do not expect more
  integer, parameter :: nHeterograms=100    ! Do not expect more
  type(t_isogram) :: allIsograms (nIsograms)
  type (t_heterogram) :: allHeterograms (nHeterograms)
  integer :: lastIsogram=0, lastHeterogram=0


  character(len=longestWord) :: word
  integer :: l, io_stat

  ! going to read all words from unixdict.txt
  open(unit=10, file='unixdict.txt', status='old', action='read', iostat=io_stat)
  if (io_stat /= 0) then
     print *, "Error opening file"
     stop
  end if

  do    ! read all words, one in a line, until ERROR or EOF
    read (10,'(A)', iostat=io_stat)   word               ! not Q format, so its ok for both intel and GNU
    l = len_trim (word)                                  ! use this instead of Q format

    if (io_stat < 0) exit    ! EOF: Normal end of this loop
    if (io_stat > 0) then
      print *, "Read error" ! ERROR: never seen this error condition
      exit
    end if
    call checkForIsoGram  (word, l)
    if (l.gt. 10) call checkForHeterogram(word, l)
  end do

  call printSortedIsoGrams()
  call printSortedHeteroGrams()

  close(10)

  contains

  ! =========================================================================
  ! Check word w with length n and store it if it is an Isogram of order >=2.
  ! =========================================================================
   subroutine checkForIsoGram (w, n)
  integer, intent(in) :: n                      ! Length of the Word
  character (len=n),intent(in) :: w             ! the word to analyse here
  integer, dimension(26) :: cnt                 ! counts multiplicity of letters in word
  integer :: ii, k, isoLength

  cnt = 0
  ! Count multiplicities of letters in w
  do ii=1, n
    k = ichar(w(ii:ii)) - ichar('a') + 1        ! Rely on ASCII
    if (k .ge.1 .and. k .le. 26) then           ! Not numeric
      cnt(k) = cnt(k) + 1
    else
      return
    endif
  end do

  isoLength = 0
  ! Condition for an Isogram: All letters come with the same, non-zero multiplicity .gt. 2
  do ii = 1, 26
    if (cnt(ii) .ne. 0) then
      if (isoLength .ne. 0) then
        if (cnt(ii) .ne. isoLength) then    ! different count detectedf:
          return                            ! Early Return: word is not an isogram
        endif
      else
        isoLength = cnt(ii)                 ! Expect all letters have this count unless 0
      endif
    endif
  end do

  ! Here if we found an isogram
  if (isolength .lt. 2)  return             ! Early return: isogram order is <2

  lastIsogram = lastIsogram + 1
  if (lastIsogram .gt. nIsograms) then      ! Error: Found more isograms than expected
    print *, 'Error: found more than ', nIsograms, ' isograms.'
    stop
  endif
  allIsograms (lastIsogram)%isoLength = isoLength
  allIsograms (lastIsogram)%word = w
  allIsograms (lastIsogram)%wordLength = l

  end subroutine checkForIsoGram


  ! ==============================================================
  ! Check word w with length n and store it if it is an Heterogram
  ! ==============================================================
  subroutine checkForHeterogram (w,n)
  integer, intent(in) ::n
  character (len=n) :: w
  integer :: ii, k, isoLength
  integer :: calls=0
  integer, dimension(26) :: cnt    ! count letters in word

  cnt = 0
  do ii=1, n
    k = ichar(w(ii:ii)) - ichar('a') + 1
    if (k .ge.1 .and. k .le. 26) then
      cnt(k) = cnt(k) + 1
    else
      return
    endif
  end do

  ! Condition for a heterogram: All letters come with the same multiplicity .eq. 1
  do ii = 1, 26
    if (cnt(ii) .ne. 0) then
      if (cnt(ii) .ne. 1) then
        return                            ! Early Return: word is not a heterogram
      endif
    endif
  end do


  lastHeterogram = lastHeterogram + 1
  if (lastHeterogram .gt. nHeterograms) then      ! Error: Found more heterograms than expected
    print *, 'Error: found more than ', nHeterograms, ' heterograms.'
    stop
  endif

  allHeterograms (lastHeterogram)%wordLength = l
  allHeterograms (lastHeterogram)%word = w

  end subroutine checkForHeterogram


  ! =================================
  ! Sort and print collected isograms
  ! =================================
  subroutine printSortedIsoGrams ()
  integer:: order, ii, wdsInLine

  call quicksort_Isograms (allIsograms, 1, lastIsogram)

  ! Now that the isograms are sorted: decreasing order, decreasing length, ascending lexicographic,
  ! we hust print them, grouped by order

  order = allIsograms(1)%isoLength
  ii = 1
  wdsInLine = 0
  do while (order .ge. 2 .and. ii .le. lastIsogram)
    print '("Isograms of Order ", i0, ":") ', order
    do while (allIsograms(ii)%isoLength .eq. order)
      write (*, '(A12,x)', advance='no')    allIsograms(ii)%word (:allIsograms(ii)%wordLength)
      wdsInLine = wdsInLine + 1
      if (wdsInLine .eq. 6) then
        wdsInLine = 0
        write (*,*) ! EOL
      endif
      ii = ii + 1
    end do
    ! Here all isograms or one order printed.
    if (wdsInLine .gt. 0) then
      write (*,*) ! EOL
      wdsInLine = 0
    endif
    order = allIsograms(ii)%isoLength

  end do
  if (wdsInLine .gt. 0) then
    write (*,*) ! EOL
    wdsInLine = 0
  endif
  end subroutine printSortedIsoGrams


  ! =========================================================================
  ! Helper: Sorts an array of isograms: decreasing order, decreasing length,
  ! ascending lexicographic order.
  ! =========================================================================
  recursive subroutine quicksort_Isograms (arr, low, high)

  type(t_isogram) :: arr (nIsograms)
  type (t_isogram) :: pivot, temp

  integer :: i, j, low, high, mid, pivot_index

  if (low .lt. high) then
    mid = low + (high-low)/2
    pivot = arr(mid)
    !Move pivot to the end
    temp = arr(mid)
    arr(mid) = arr(high)
    arr(high)=temp
    i = low-1
    do j=low,high-1
      if (is_le_isogram (arr(j), pivot)) then
        i = i + 1
        temp = arr(i)
        arr(i) = arr(j)
        arr(j) = temp
      endif
    enddo
    temp = arr(i+1)
    arr(i+1) = arr(high)
    arr(high) = temp
    pivot_index = i + 1
    call quicksort_Isograms(arr, low, pivot_index - 1)
    call quicksort_Isograms(arr, pivot_index + 1, high)
  endif
  end subroutine quicksort_Isograms

  ! ========================================================
  ! Helper function: when comes isogram l before isogram r?
  ! ========================================================
  function is_le_isogram (l, r) result (is_le)

    type(t_isogram), intent(in) :: l, r
    logical :: is_le

    is_le = .false.

    if (l%word(:l%wordLength) .eq. r%word(:r%wordLength) .and. &
        l%wordLength .eq. r%wordLength                   .and. &
        l%isoLength .eq. r%isoLength)  then                                 ! l .we. r: le is true.
      is_le = .true.
      return
    else if (l%isoLength .gt. r%isoLength) then       ! Order decreasing: higher first
      is_le = .true.
      return
    else if (l%isoLength .eq. r%isoLength) then
      if (l%wordLength .gt. r%wordLength) then        ! Decreasing word lengrth: longer first
        is_le = .true.
        return
      else if (l%wordLength .eq. r%wordLength) then
        if (l%word .lt. r%word) then                  ! lexicographic .lt.
          is_le = .true.
         else
          is_le = .false.                             ! anything else failed.
        endif
      endif
    endif

  end function is_le_isogram



  ! ====================================
  ! Sort and print collected heterograms
  ! ====================================
  subroutine printSortedHeteroGrams ()
  integer:: ii, wdsInLine

  call quicksort_Heterograms (allHeterograms, 1, lastHeterogram)

  wdsinLine = 0
  write (*, '(/,"Heterograms longer than 10 characters:")')
  do ii=1, lastHeterogram

      write (*, '(A12,X)', advance='no')    allHeterograms(ii)%word (:allHeterograms(ii)%wordLength)
      wdsInLine = wdsInLine + 1
      if (wdsInLine .eq. 6) then
        wdsInLine = 0
        write (*,*) ! EOL
      endif
  enddo
  if (wdsInLine .gt. 0) write (*,*)

  end subroutine printSortedHeteroGrams


  ! ==========================================================================
  ! Helper: Sorts an array of heterograms: decreasing order, decreasing length,
  ! ascending lexicographic order.
  ! ==========================================================================
  recursive subroutine quicksort_Heterograms (arr, low, high)

  type(t_Heterogram) :: arr (nHeterograms)
  type (t_Heterogram) :: pivot, temp

  integer :: i, j, low, high, mid, pivot_index

  if (low .lt. high) then
    mid = low + (high-low)/2
    pivot = arr(mid)
    !Move pivot to the end
    temp = arr(mid)
    arr(mid) = arr(high)
    arr(high)=temp
    i = low-1
    do j=low,high-1
      if (is_le_Heterogram (arr(j), pivot)) then
        i = i + 1
        temp = arr(i)
        arr(i) = arr(j)
        arr(j) = temp
      endif
    enddo
    temp = arr(i+1)
    arr(i+1) = arr(high)
    arr(high) = temp
    pivot_index = i + 1
    call quicksort_Heterograms(arr, low, pivot_index - 1)
    call quicksort_Heterograms(arr, pivot_index + 1, high)
  endif
  end subroutine quicksort_Heterograms

  ! ===========================================================
  ! Helper function: when comes heterogram l before isogram r?
  ! ===========================================================
  function is_le_Heterogram  (l, r) result (is_le)
    type(t_Heterogram), intent(in) :: l, r
    logical :: is_le

    is_le = .false.

    if (l%word(:l%wordLength) .eq. r%word(:r%wordLength) .and. &
        l%wordLength .eq. r%wordLength )  then                                 ! l .we. r: le is true.
      is_le = .true.
      return
    else if (l%wordLength .gt. r%wordLength) then        ! Decreasing word lengrth: longer first
      is_le = .true.
      return
    else if (l%wordLength .eq. r%wordLength) then
      if (l%word .lt. r%word) then                  ! lexicographic .lt.
        is_le = .true.
      else
        is_le = .false.                             ! anything else failed.
      endif
    endif
  end function is_le_Heterogram

end program Isograms
