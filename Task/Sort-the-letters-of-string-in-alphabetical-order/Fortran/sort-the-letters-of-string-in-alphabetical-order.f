program sort_string
  implicit none
  character(len=100) :: input_string
  character(len=100) :: sorted_string

 input_string = "When I was a little boy, my Mama said to me 'Who do you think you''re fooling'"

  sorted_string = sort_chars(input_string)
  print *, 'Original string:',trim(input_string)
  print *, 'Sorted string:', trim(sorted_string)

contains

  function sort_chars(str) result(sorted_str)
    character(len=*), intent(in) :: str
    character(:),allocatable :: sorted_str
    integer :: i, j
    character :: temp
    i = len_trim(str)
    allocate(character(i) :: sorted_str)
    sorted_str = str(1:i)

    do i = 1, len(sorted_str) - 1
      do j = i + 1, len(sorted_str)
        if (ichar(sorted_str(j:j)) < ichar(sorted_str(i:i))) then
          temp = sorted_str(i:i)
          sorted_str(i:i) = sorted_str(j:j)
          sorted_str(j:j) = temp
        end if
      end do
    end do
  end function sort_chars

end program sort_string

