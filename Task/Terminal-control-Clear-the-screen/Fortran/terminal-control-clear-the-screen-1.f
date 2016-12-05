program clear
    character(len=:), allocatable :: clear_command
    clear_command = "clear" !"cls" on Windows, "clear" on Linux and alike
    call execute_command_line(clear_command)
end program
