program happy

  implicit none
  integer, parameter :: find = 8
  integer :: found
  integer :: number

  found = 0
  number = 1
  do
    if (found == find) then
      exit
    end if
    if (is_happy (number)) then
      found = found + 1
      write (*, '(i0)') number
    end if
    number = number + 1
  end do

contains

  function sum_digits_squared (number) result (result)

    implicit none
    integer, intent (in) :: number
    integer :: result
    integer :: digit
    integer :: rest
    integer :: work

    result = 0
    work = number
    do
      if (work == 0) then
        exit
      end if
      rest = work / 10
      digit = work - 10 * rest
      result = result + digit * digit
      work = rest
    end do

  end function sum_digits_squared

  function is_happy (number) result (result)

    implicit none
    integer, intent (in) :: number
    logical :: result
    integer :: turtoise
    integer :: hare

    turtoise = number
    hare = number
    do
      turtoise = sum_digits_squared (turtoise)
      hare = sum_digits_squared (sum_digits_squared (hare))
      if (turtoise == hare) then
        exit
      end if
    end do
    result = turtoise == 1

  end function is_happy

end program happy
