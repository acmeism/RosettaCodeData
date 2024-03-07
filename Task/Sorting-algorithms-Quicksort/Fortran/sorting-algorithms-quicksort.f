       recursive subroutine fsort(a)
      use inserts, only:insertion_sort !Not included in this posting
      implicit none
!
! PARAMETER definitions
!
      integer, parameter  ::  changesize = 64
!
! Dummy arguments
!
      real, dimension(:) ,contiguous ::  a
      intent (inout) a
!
! Local variables
!
      integer  ::  first = 1
      integer  ::  i
      integer  ::  j
      integer  ::  last
      logical  ::  stay
      real  ::  t
      real  ::  x
!
!*Code
!
      last = size(a, 1)
      if( (last - first)<changesize )then
          call insertion_sort(a(first:last))
          return
      end if
      j = shiftr((first + last), 1) + 1
                                     !
      x = a(j)
      i = first
      j = last
      stay = .true.
      do while ( stay )
          do while ( a(i)<x )
              i = i + 1
          end do
          do while ( x<a(j) )
              j = j - 1
          end do
          if( j<i )then
              stay = .false.
          else
              t = a(i)      ! Swap the values
              a(i) = a(j)
              a(j) = t
              i = i + 1     ! Adjust the pointers (PIVOT POINTS)
              j = j - 1
          end if
      end do
      if( first<i - 1 )call fsort(a(first:i - 1))   ! We still have some left to do on the lower
      if( j + 1<last )call fsort(a(j + 1:last))     ! We still have some left to do on the upper
      return
      end subroutine fsort
