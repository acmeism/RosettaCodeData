program reverse_string

  implicit none
  character (*), parameter :: string = 'no devil lived on'

  write (*, '(a)') string
  write (*, '(a)') reverse (string)

contains

  recursive function reverse (string) result (res)

    implicit none
    character (*), intent (in) :: string
    character (len (string)) :: res

    if (len (string) == 0) then
      res = ''
    else
      res = string (len (string) :) // reverse (string (: len (string) - 1))
    end if

  end function reverse

end program reverse_string
