! Hex words
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
! but not VSI Fortran x86-64 V8.7-001 because that compiler does not accept
! allocatable character variables
!

module modType

implicit none
public t_hexw
type  :: t_hexw
  integer :: decroot
  integer :: value
  character (len=:), allocatable   :: word
  integer :: len
end type

end module modType


program Hexwords
use modType

implicit none

integer :: capacity, used

integer, parameter :: longestWord=25            ! no word in unixdict.txt is longer.
character(len=longestWord)    ::  word
character(len=longestWord),parameter :: filename = 'unixdict.txt'

integer :: l, io_stat                                       ! Length of read word, and status of read operation
integer :: ival, decroot
integer :: ii, jj

type (t_hexw), allocatable  :: resultWords(:), tmp(:)

interface                                     ! for the compare functions used to call quicksort
 function compValue (l,r) result (yn)
    use modType
    type (t_hexw),intent(in) :: l, r
    logical :: yn
  end function compValue
  function compRoot (l,r) result (yn)
    use modType
    type (t_hexw),intent(in) :: l, r
    logical :: yn
  end function compRoot
end interface

capacity = 32
used=0

allocate (resultWords(capacity))

open(unit=10, file=filename, status='old', action='read', iostat=io_stat)
if (io_stat .ne. 0) then
   print *, "Error opening file ", filename
   stop
end if
do
  read(10, '(a)', iostat=io_stat) word
  if (io_stat .lt. 0) exit          ! EOF, normal end of input
  if (io_stat .gt. 0) then          ! read error, unexpected failure
    print *, "Read error"
    exit
  end if

  l = len_trim (word)
  if (l .lt. 4) cycle ! only consider words with 4 letters or more

  if (is_hexword (word(1:l), l)) then
    ival = base10(word(1:l))
    decroot = decimalRoot (ival)
    used = used + 1
    if (used .gt. capacity) then
      call move_alloc(resultWords, tmp)
      allocate (resultWords (2*capacity))
      resultWords (:capacity) = tmp(:capacity)
      capacity = 2*capacity
    endif
    resultWords (used)%decroot = decroot
    resultWords (used)%value = ival
    resultWords (used)%word = word(:l)
    resultWords (used)%len = l
  endif

end do

! Sort according to increasing root and print all entries
call quicksort (resultWords, 1, used, compRoot)
write (*,'("Digital root   Word   Decimal value")')
do jj=1,used
  write (*,'(6x,i1,7x, A5, 3x, i10)') resultWords(jj)%decroot, resultWords(jj)%word(1:resultWords(jj)%len), resultWords(jj)%value
enddo
write (*,'(/,"Total count:", i2)')    used

write (*,'(/,"Digital root   Word   Decimal value")')

! sort according decreasing value, then select and print only words with at least 4 distinct characters,
call quicksort (resultWords, 1, used, compValue)
ii = 0
do jj=1,used
  if (DistinctLetters (resultWords (jj)%word, resultWords (jj)%len) .ge.4)  then
    ii = ii + 1                         ! Abuse ii to count output lines here.
    write (*,'(6x,i1,7x, A5, 3x, i10)') resultWords(jj)%decroot, resultWords(jj)%word(1:resultWords(jj)%len), resultWords(jj)%value
  endif
enddo
write (*,'(/,"Total count:", i2)')   ii



close(10)

contains


recursive subroutine quicksort (a, low, high, comparefunc)
use modType
implicit none

type (t_hexw), intent(inout), dimension(:)  :: a
type (t_hexw) :: temp
integer , intent(in) :: low, high

integer :: pivot, i, j, mid, pivot_index

interface
  function comparefunc (l,r) result (yn)
    use modType
    type (t_hexw),intent(in) :: l, r
    logical :: yn
  end function comparefunc
end interface

if (low .lt. high) then
  mid=low+(high-low)/2
  pivot = a(mid)%value

  ! Move pivot to the end
  temp = a(mid)
  a(mid) = a(high)
  a(high) = temp
  i = low-1

  do j=low,high-1
    if (comparefunc (a(j), a(high))) then
      i = i + 1
      temp=a(i)
      a(i) = a(j)
      a(j)=temp
    endif
  enddo
  temp=a(i+1)
  a(i+1) = a(high)
  a(high)=temp
  pivot_index = i+1
  call quicksort (a,low,pivot_index-1, comparefunc)
  call quicksort (a,pivot_index+1, high, comparefunc)
endif


end subroutine quicksort



function DistinctLetters (w, l) result (n)
integer, intent(in) :: l
character (len=l), intent(in) :: w

integer :: ii, jj
integer :: n
integer ::seen

n = 0

do ii=1,l
  seen = 0
  do jj=1, ii-1        ! But it does not if already seen atleast once
    if (w(ii:ii) .eq. w(jj:jj)) then
      seen = 1
      exit
    endif
  enddo
  if (seen .eq. 0) n=n+1
end do
end function DistinctLetters

function is_hexword (t, l) result (YN)
character (len=*), intent(in)  :: t
integer , intent(in) :: l
logical :: YN

integer :: ii
do ii=1,l
  if (index('abcdefABCDEF',t(ii:ii)) .eq. 0) then
    YN = .false.
    return
  endif
enddo

YN = .true.
end function is_hexword

function base10 (t) result (intnum)
character (len=*), intent(in)  :: t
integer :: intnum


read (t,'(Z5)')   intnum
end function base10


recursive function decimalRoot (n) result (r)
integer, intent(in) :: n
integer :: r

integer:: wn

wn = N
r=0
do while (wn .ne. 0)
  r = r + mod(wn,10)
  wn = wn / 10
enddo
! go recursive if digit sum r is >= 10
if   (r .ge. 10) r = decimalRoot (r)
end function decimalRoot


end program Hexwords

function compvalue (l,r) result (yn)
  use modType
  implicit none
  type (t_hexw),intent(in) :: l,r
  logical :: YN

  yn = l%value .ge. r%value
end function compvalue

function compRoot (l,r) result (yn)
  use modType
  implicit none
  type (t_hexw),intent(in) :: l,r
  logical :: YN

  yn = l%decroot .le. r%decroot
end function compRoot
