program type_detection_demo

  implicit none

  type text_block_t
     character(len = 10000), allocatable :: lines(:)
  end type text_block_t

  interface print_text
     procedure print_text_text_block_t
     procedure print_text_file_unit
  end interface print_text

  type(text_block_t) :: text_block
  integer :: i

  allocate (text_block%lines(1:10))
  do i = 1, 10
     write (text_block%lines(i), '("i = ", I0)') i
  end do
  call print_text (text_block)

  open (100, file = 'type_detection-fortran-2.f90', action = 'read')
  call print_text (100)
  close (100)

contains

  subroutine print_text_text_block_t (source)
    class(text_block_t), intent(in) :: source

    integer :: i

    do i = lbound (source%lines, 1), ubound (source%lines, 1)
       write (*, '(A)') trim (source%lines(i))
    end do
  end subroutine print_text_text_block_t

  subroutine print_text_file_unit (source)
    integer, intent(in) :: source

    character(len = 10000) :: line_buffer
    integer :: stat

    read (source, '(A)', iostat = stat) line_buffer
    do while (stat == 0)
       write (*, '(A)') trim (line_buffer)
       read (source, '(A)', iostat = stat) line_buffer
    end do
  end subroutine print_text_file_unit

end program type_detection_demo
