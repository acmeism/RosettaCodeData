!------------------------------------------------------------------------------
! Module: quickselect_mod
!
! Description:
!   Hoare's QuickSelect algorithm: find the K-th smallest element in an
!   unsorted integer array in average O(N) time.
!
!   The array is partially sorted as a side effect: on return,
!     A(i) <= A(K)  for all i < K
!     A(i) >= A(K)  for all i > K
!   so A(K) holds the K-th order statistic.
!
!   Useful special cases:
!     K = 1         : minimum element
!     K = N         : maximum element
!     K = (N+1)/2   : lower median
!
!   The pivot at each step is A(K) itself.  Because K lies within the search
!   window [L,R] at every iteration, A(K) is always a valid partition value
!   and the window narrows by at least one element per pass.
!
!   Average time: O(N).  Worst case: O(N^2) when the pivot is always extreme
!   (e.g., already-sorted input).  For robust median finding on large arrays
!   consider Introselect (median-of-medians pivot selection).
!
! Reference:
!   C.A.R. Hoare, "Algorithm 65: Find", Communications of the ACM, 1961.
!
! Authors:
!   Original algorithm: C.A.R. Hoare
!
!------------------------------------------------------------------------------

module quickselect_mod
   implicit none
   private
   public :: quickselect

contains

   !---------------------------------------------------------------------------
   ! quickselect -- return the K-th smallest element of A(1:N).
   !
   ! The array A is partially rearranged in place; see module header.
   !---------------------------------------------------------------------------
   integer function quickselect(k, a, n)
      integer, intent(in) :: k ! order position wanted (1-based)
      integer, intent(in) :: n ! number of elements
      integer, intent(inout) :: a(n) ! array; partially sorted on exit

      integer :: l, r, l2, r2 ! outer and inner scan fingers
      integer :: pivot ! partition value (= A(K) each pass)
      integer :: tmp ! swap temporary

      l = 1
      r = n

      do while (l < r)
         pivot = a(k) ! A(K) lies in [L,R], so this is always valid.
         l2 = l
         r2 = r

         ! Partition loop: squeeze l2 and r2 inward until they cross.
         ! Invariant: A(L..l2-1) < pivot, A(r2+1..R) > pivot.
         do while (l2 <= r2)

            ! Advance left finger past elements already in the right place.
            do while (a(l2) < pivot)
               l2 = l2 + 1
            end do

            ! Retreat right finger past elements already in the right place.
            do while (pivot < a(r2))
               r2 = r2 - 1
            end do

            ! l2 and r2 have stalled on out-of-order elements (or met).
            if (l2 <= r2) then
               if (l2 < r2) then ! stalled on two elements: swap them
                  tmp = a(l2)
                  a(l2) = a(r2)
                  a(r2) = tmp
               end if
               l2 = l2 + 1 ! advance past the (now correct) pair
               r2 = r2 - 1
            end if

         end do

         ! After partition, r2 < l2.
         ! r2 is the final position of the last element <= pivot.
         ! l2 is the final position of the first element >= pivot.
         ! Narrow the outer window to the side that contains K.
         if (r2 < k) l = l2
         if (k < l2) r = r2

      end do

      quickselect = a(k)

   end function quickselect

end module quickselect_mod

program poke
   use quickselect_mod
   implicit none
   integer :: i
   integer, parameter :: n = 10 !Fixed for the test problem.
   integer :: a(66) !An array of integers.
   data a(1:n)/9, 8, 7, 6, 5, 0, 1, 2, 3, 4/ !The specified values.

   write(6, 1) a(1:n) !Announce, and add a heading.
   1 format("Selection of the i'th element in order from an array.", /, "The array need not be in order, and may be reordered.", & /, (*(i0, 1x)))
   2 format(t11, "i Val:Array elements...")
   3 format(t8, I3, I4, ":", (*(I0, 1x)))
   write(6, 2)
   do i = 1, n !One by one,
      write(6, 3) i, quickselect(i, a, n), a(1:n) !Request the i'th element.

   end do

end program poke
