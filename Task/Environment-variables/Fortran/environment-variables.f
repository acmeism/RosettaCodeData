program show_home
implicit none
character(len=32) :: home_val  ! The string value of the variable HOME
integer           :: home_len  ! The actual length of the value
integer           :: stat      ! The status of the value:
                               !  0 = ok
                               !  1 = variable does not exist
                               ! -1 = variable is not long enought to hold the result
call get_environment_variable('HOME', home_val, home_len, stat)
if (stat == 0) then
    write(*,'(a)') 'HOME = '//trim(home_val)
else
    write(*,'(a)') 'No HOME to go to!'
end if
end program show_home
