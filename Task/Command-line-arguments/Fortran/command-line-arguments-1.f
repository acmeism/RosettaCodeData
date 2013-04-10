program command_line_arguments

  implicit none
  integer, parameter :: len_max = 256
  integer :: i , nargs
  character (len_max) :: arg

  nargs = command_argument_count()
  !nargs = iargc()
  do i = 0, nargs
    call get_command_argument (i, arg)
    !call getarg (i, arg)
    write (*, '(a)') trim (arg)
  end do

end program command_line_arguments
