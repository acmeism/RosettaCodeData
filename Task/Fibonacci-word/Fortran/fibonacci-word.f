! Fibonacci word
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
! but not VSI Fortran x86-64 V8.7-001 because that compiler does not accept
! allocatable character variables
!

program FibonacciWord

character (len=:),  allocatable :: fw1,fw2,fw3
integer :: i, j, ones, zeros

fw1 = '1'
fw2 = '0'

i = 2

! Print top line and first 2 lines that aren't within the do-loop
print *, 'N   Length    Entropy Fibword'
call printLine (1,fw1)
call printLine (2,fw2)

! Print lines 3 through 37 as requested in the task descrtiption
do j=3,37
  !
  ! Use rotating index i instead of moving long strings around:
  ! calculate fw(i) as concatenation of the two other fw's in the correct order.
  !
  i = i+1
  if (i .gt.3) i=1
  select case (i)
    case (1)
      fw1 = fw3 // fw2
      call printLine (j, fw1)
    case (2)
      fw2 = fw1 // fw3
      call printLine (j, fw2)
    case (3)
      fw3 = fw2 // fw1
      call printLine (j, fw3)
    end select
enddo

contains

! =================================================================================================
! Print 1 output line: N, the Length of the FibWord, its Entropy, and the word unless it's too long
! =================================================================================================
subroutine printLine (ii, txt)
integer, intent(in) :: ii                   ! Line number
character (len=*),intent(in) :: txt         ! The FibWord to print
integer :: l, i                             ! Length, loop index

real (kind=8)  :: count_0,count_1,tot       ! Count 0's and 1's in txt
real (kind=8)  :: Entropy                   ! Resulting entropy

count_1 = 0
count_0 = 0
l = len(txt)
do i=1,l
  if (txt(i:i) .eq. '0')  then
    count_0 = count_0 + 1_8
  else
    count_1 = count_1 + 1_8
  endif
end do
tot = count_1+count_0

if (count_1 .eq. 0 .or. count_0 .eq. 0) then    ! Calc log(0) is undefined. Use 0
  Entropy =0.0_8
else
  Entropy =  - count_1 / tot * log2( count_1 / tot);
  Entropy =  Entropy - count_0 / tot * log2( count_0 / tot);
endif
if (l .lt.  60) then
  write (6,'(i2,X, i8, X, F10.8, X, A )') ii, l, Entropy, txt
else
  write (6,'(i2,X, i8, X, F10.8, X, A )') ii, l, Entropy, '(...)'
endif
end subroutine printLine

! =================================================
! Helper, Fortran knows LOG and LOG10 but not LOG2.
! Just a trivial base change
! =================================================
function log2 (x) result (r)
real (kind=8), intent(in) ::x
real (kind=8) ::r
r = log(x) / log(2.)
end function log2
end program FibonacciWord
