program StdErr
  ! Fortran 2003
  use iso_fortran_env

  ! in case there's no module iso_fortran_env ...
  !integer, parameter :: ERROR_UNIT = 0

  write (ERROR_UNIT, *) "Goodbye, World!"
end program StdErr
