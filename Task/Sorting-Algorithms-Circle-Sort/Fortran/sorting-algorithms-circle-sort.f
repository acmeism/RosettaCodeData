!
module circlesort
! I have commented the code that was here and also 'tightened up' various pieces such as how swap detection was done as well
! as fixing an error where the code would exceed array bounds for odd number sized arrays.
! Also, giving some some attribution to the author. - Pete
! This code is a Fortran adaptation of a Forth algorithm laid out by "thebeez" at this URL;
! https://sourceforge.net/p/forth-4th/wiki/Circle%20sort/
!
  implicit none
  logical, private :: csr
  public :: circle_sort

contains

  recursive logical function csr(a, left, right,n) result(swapped)
    implicit none
    integer, intent(in) :: left, right,n
    integer, intent(inout) :: a(n)
    integer :: lo, hi, mid
    integer :: temp
    logical :: lefthalf,righthalf
!
    swapped = .FALSE.
    if (right <= left) return
    lo = left   !Store the upper and lower bounds of list for
    hi = right  !Recursion later
!
    do while (lo < hi)
!   Swap the pair of elements if hi < lo
       if (a(hi) < a(lo)) then
          swapped = .TRUE.
          temp = a(lo)
          a(lo) = a(hi)
          a(hi) = temp
       endif
       lo = lo + 1
       hi = hi - 1
    end do
!   Special case if array is an odd size (not even)
    if (lo == hi)then
       if(a(hi+1) .lt. a(lo))then
           swapped = .TRUE.
           temp = a(hi+1)
           a(hi+1) = a(lo)
           a(lo) = temp
       endif
    endif
    mid = (left + right) / 2 ! Bisection point
    lefthalf = csr(a, left, mid,n)
    righthalf = csr(a, mid + 1, right,n)
    swapped = swapped .or. lefthalf .or. righthalf
  end function csr
!
  subroutine circle_sort(a, n)
    use iso_c_binding, only: c_ptr, c_loc
    implicit none
    integer, intent(in) :: n
    integer, target,intent(inout) :: a(n)

    do while ( csr(a, 1, n,n))
! This is the canonical algorithm. However, if you want to
! speed it up, count the iterations and when you have approached
! 0.5*ln(n) iterations, perform a binary insertion sort then exit the loop.
    end do
  end subroutine circle_sort

end module circlesort
program sort
  use circlesort
  implicit none
  integer :: a(9)
  data a/6,7,8,9,2,5,3,4,1/
  call circle_sort(a, size(a))
  print *, a
end program sort
