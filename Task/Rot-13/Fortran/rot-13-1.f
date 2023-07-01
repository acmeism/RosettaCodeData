program test_rot_13

  implicit none
  integer, parameter :: len_max = 256
  integer, parameter :: unit = 10
  character (len_max) :: file
  character (len_max) :: fmt
  character (len_max) :: line
  integer :: arg
  integer :: arg_max
  integer :: iostat

  write (fmt, '(a, i0, a)') '(a', len_max, ')'
  arg_max = iargc ()
  if (arg_max > 0) then
! Encode all files listed on the command line.
    do arg = 1, arg_max
      call getarg (arg, file)
      open (unit, file = file, iostat = iostat)
      if (iostat /= 0) cycle
      do
        read (unit, fmt = fmt, iostat = iostat) line
        if (iostat /= 0) exit
        write (*, '(a)') trim (rot_13 (line))
      end do
      close (unit)
    end do
  else
! Encode standard input.
    do
      read (*, fmt = fmt, iostat = iostat) line
      if (iostat /= 0) exit
      write (*, '(a)') trim (rot_13 (line))
    end do
  end if

contains

  function rot_13 (input) result (output)

    implicit none
    character (len_max), intent (in) :: input
    character (len_max) :: output
    integer :: i

    output = input
    do i = 1, len_trim (output)
      select case (output (i : i))
      case ('A' : 'M', 'a' : 'm')
        output (i : i) = char (ichar (output (i : i)) + 13)
      case ('N' : 'Z', 'n' : 'z')
        output (i : i) = char (ichar (output (i : i)) - 13)
      end select
    end do

  end function rot_13

end program test_rot_13
