program check_terminal
  use iso_c_binding
  implicit none

  logical :: is_terminal

  ! Check if standard output (unit 6) is a terminal
  is_terminal = isatty(6)

  if (is_terminal) then
     print *, 'Standard output is a terminal.'
  else
     print *, 'Standard output is not a terminal (e.g., redirected to a file).'
  end if

end program check_terminal
