program input_type_detection_demo
  implicit none

  type text_block_t
     character(len = 10000), allocatable :: lines(:)
  end type text_block_t

  type(text_block_t) :: text_block
  integer :: i

  call print_text ('Print me.')

  allocate (text_block%lines(1:10))
  do i = 1, 10
     write (text_block%lines(i), '("i = ", I0)') i
  end do
  call print_text (text_block)

  open (100, file = 'type_detection-fortran.f90', action = 'read')
  call print_text (100)
  close (100)

contains

  subroutine print_text (source)
    class(*), intent(in) :: source

    select type (source)

    type is (character(len = *))
       ! Print a single character string.
       write (*, '(A)') source

    class is (text_block_t)
       ! Print an array of lines.
       block
         integer :: i
         do i = lbound (source%lines, 1), ubound (source%lines, 1)
            write (*, '(A)') trim (source%lines(i))
         end do
       end block

    type is (integer)
       ! Print a file.
       block
         character(len = 10000) :: line_buffer
         integer :: stat
         read (source, '(A)', iostat = stat) line_buffer
         do while (stat == 0)
            write (*, '(A)') trim (line_buffer)
            read (source, '(A)', iostat = stat) line_buffer
         end do
       end block

    class default
       ! There is no handler for the type.
       error stop

    end select
  end subroutine print_text

end program input_type_detection_demo
