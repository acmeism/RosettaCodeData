! Farey Sequence
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program Farey

implicit none

! These variables are used in "contained" subtoutines and functions
integer :: n,a,b,c,d    ! Order, and current 2 terms of a Farey Sequence

! Local variables here in Main program:
integer :: ii, count  ! Loop index, counter for terms in sequence

! compute and show the Farey sequence for orders 1 through 11 (inclusive).

do ii=1, 11
  call startNew (ii)
  write (*, '(I2, ": ")', advance='no') n         ! Advance 'no' to print all in 1 line
  count = 0
  do
    count = count + 1                             ! Count to limit line length
    write (*,'(i0, "/",i0)', advance='no') a, b   ! Advance 'no' to print them in 1 line
    if (.not. expectNext())    Exit               ! Finish when sequence complete
    write (*, '(", ")', advance='no')             ! more is coming - print separator
    if (count .eq. 10) then                       ! By default, OpenVMS does not like
      count = 0                                   ! long output lines and produces a run-time
      write (*,'(/,4x)', advance='no')            ! error when line length exceeds 132
    endif
    call next()                                   ! Calculate next term
  enddo
  write (*, *)                                    ! Terminate line
enddo

! compute and display the number of fractions in the Farey sequence for order 100 through 1,000 inclusive)   by hundreds.
write (*,*)                                       ! empty line
do ii=100, 1000, 100
  count = 0
  call startNew (ii)
  write (*, '(I4, ": ")', advance='no') n
  do
    count = count + 1                             ! Dont print the terms, just count them
    if (.not. expectNext()) Exit
    call next()
  enddo
  write (*, '(I0)')   count
 end do
contains


! =========================================
! Start a new Farey Sequence or order newN
! =========================================
subroutine startNew(newN)
integer, intent(in) :: newN

n = newN
a = 0       ! 1st term is a/b=0/1
b = 1
c = 1       ! 2nd term is c/d=(1/n)
d = n

end subroutine startNew

! =================================================
! Calculate next term in the current Farey Sequence
! =================================================
subroutine next()
!
! The algorithm to calculate next term a/b of the sequence is
! described in Wikipedia, https://en.wikipedia.org/wiki/Farey_sequence

integer :: fact, nextC, nextD

fact = (n+b) / d
nextC = fact*c - a
nextD = fact*d - b

a = c
b = d
c = nextC
d = nextD

end subroutine next

! ==========================================================
! Say Yes if more terms in current sequence can be expected
! ==========================================================
function expectNext() result (YN)

! The end is reached when the last term (1/1) is encountered.
logical :: YN

YN = a .ne. 1 .or. b .ne. 1
end function expectNext

end program Farey
