module pangram

  implicit none
  private
  public :: is_pangram
  character (*), parameter :: lower_case = 'abcdefghijklmnopqrstuvwxyz'
  character (*), parameter :: upper_case = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

contains

  function to_lower_case (input) result (output)

    implicit none
    character (*), intent (in) :: input
    character (len (input)) :: output
    integer :: i
    integer :: j

    output = input
    do i = 1, len (output)
      j = index (upper_case, output (i : i))
      if (j /= 0) then
        output (i : i) = lower_case (j : j)
      end if
    end do

  end function to_lower_case

  function is_pangram (input) result (output)

    implicit none
    character (*), intent (in) :: input
    character (len (input)) :: lower_case_input
    logical :: output
    integer :: i

    lower_case_input = to_lower_case (input)
    output = .true.
    do i = 1, len (lower_case)
      if (index (lower_case_input, lower_case (i : i)) == 0) then
        output = .false.
        exit
      end if
    end do

  end function is_pangram

end module pangram
