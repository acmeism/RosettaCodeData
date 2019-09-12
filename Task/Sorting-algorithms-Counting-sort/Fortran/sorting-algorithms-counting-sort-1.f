module CountingSort
  implicit none

  interface counting_sort
     module procedure counting_sort_mm, counting_sort_a
  end interface

contains

  subroutine counting_sort_a(array)
    integer, dimension(:), intent(inout) :: array

    call counting_sort_mm(array, minval(array), maxval(array))

  end subroutine counting_sort_a

  subroutine counting_sort_mm(array, tmin, tmax)
    integer, dimension(:), intent(inout) :: array
    integer, intent(in) :: tmin, tmax

    integer, dimension(tmin:tmax) :: cnt
    integer :: i, z

    cnt = 0                   ! Initialize to zero to prevent false counts
    FORALL (I=1:size(array))  ! Not sure that this gives any benefit over a DO loop.
        cnt(array(i)) = cnt(array(i))+1
    END FORALL
!
!   ok - cnt contains the frequency of every value
!   let's unwind them into the original array
!
    z = 1
    do i = tmin, tmax
       do while ( cnt(i) > 0 )
          array(z) = i
          z = z + 1
          cnt(i) = cnt(i) - 1
       end do
    end do

  end subroutine counting_sort_mm

end module CountingSort
