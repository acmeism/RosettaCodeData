program test_sleep

  implicit none
  integer :: iostat
  integer :: seconds
  character (32) :: argument

  if (iargc () == 1) then
    call getarg (1, argument)
    read (argument, *, iostat = iostat) seconds
    if (iostat == 0) then
      write (*, '(a)') 'Sleeping...'
      call sleep (seconds)
      write (*, '(a)') 'Awake!'
    end if
  end if

end program test_sleep
