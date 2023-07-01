module sorts_with_custom_comparator
  implicit none
contains
  subroutine a_sort(a, cc)
    character(len=*), dimension(:), intent(inout) :: a
    interface
       integer function cc(a, b)
         character(len=*), intent(in) :: a, b
       end function cc
    end interface

    integer :: i, j, increment
    character(len=max(len(a), 10)) :: temp

    increment = size(a) / 2
    do while ( increment > 0 )
       do i = increment+1, size(a)
          j = i
          temp = a(i)
          do while ( j >= increment+1 .and. cc(a(j-increment), temp) > 0)
             a(j) = a(j-increment)
             j = j - increment
          end do
          a(j) = temp
       end do
       if ( increment == 2 ) then
          increment = 1
       else
          increment = increment * 5 / 11
       end if
    end do
  end subroutine a_sort
end module sorts_with_custom_comparator
