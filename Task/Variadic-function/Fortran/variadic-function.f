program varargs

  integer, dimension(:), allocatable :: va
  integer :: i

  ! using an array (vector) static
  call v_func()
  call v_func( (/ 100 /) )
  call v_func( (/ 90, 20, 30 /) )

  ! dynamically creating an array of 5 elements
  allocate(va(5))
  va = (/ (i,i=1,5) /)
  call v_func(va)
  deallocate(va)

contains

  subroutine v_func(arglist)
    integer, dimension(:), intent(in), optional :: arglist

    integer :: i

    if ( present(arglist) ) then
       do i = lbound(arglist, 1), ubound(arglist, 1)
          print *, arglist(i)
       end do
    else
       print *, "no argument at all"
    end if
  end subroutine v_func

end program varargs
