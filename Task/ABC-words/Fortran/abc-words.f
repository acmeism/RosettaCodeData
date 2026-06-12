! ABC Words
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! Note that VMS requires switch $Fortran/ccdefault=LIST
! otherwise 1st character of each output line is interpreted as
! Carriage Control character.
!
! U.B., July 2025
!

program abc_words

  implicit none

  character(len=100)    ::  word                              ! long enough to carry longes expected word
  character(len=12),parameter :: filename = 'unixdict.txt'
  integer :: l, io_stat                                       ! Length of read word, and status of read operation
  integer :: abc_wordcount=0                                  ! counter for detected abc words

  open(unit=10, file=filename, status='old', action='read', iostat=io_stat)
  if (io_stat /= 0) then
     print *, "Error opening file ", filename
     stop
  end if

  do
    read(10, '(a)', iostat=io_stat) word
    l = len_trim (word)
    if (io_stat < 0) exit          ! EOF, normal end of input
    if (io_stat > 0) then          ! read error, unexpected failure
      print *, "Read error"
      exit
    end if
    if (is_abc(word(1:l))) then
      print '(A)', word(1:l)
      abc_wordcount = abc_wordcount + 1
    end if

  end do

  close(10)

  print '(/"File ", A, " contains ", i0, " ABC words")', filename, abc_wordcount

   contains

   function is_abc (word) result (word_is_abcword)
   character(len=*), intent(in)  :: word
   logical                       :: word_is_abcword

   integer                       :: posABC(3)

   posABC = locateABC (word)
   word_is_abcword = posABC(1) .gt. 0 .and. posABC(1) < posABC(2) .and. posABC(2) .lt. posABC(3)
   end function is_abc

   function locateABC (word)   result (posABC)

   character(len=*), intent(in)  :: word
   integer                       :: posABC(3)
   integer                       :: ii

   posABC(1)=0
   posABC(2)=0
   posABC(3)=0

   do ii=1, len_trim (word)
      if (word(ii:ii) .eq. 'a') then
         if (posABC(1) .eq. 0) posABC(1) = ii
      else if (word(ii:ii) .eq. 'b') then
         if (posABC(2) .eq. 0) posABC(2) = ii
      else if (word(ii:ii) .eq. 'c') then
         if (posABC(3) .eq. 0) posABC(3) = ii
      endif
   enddo
   end function locateABC

end program abc_words

