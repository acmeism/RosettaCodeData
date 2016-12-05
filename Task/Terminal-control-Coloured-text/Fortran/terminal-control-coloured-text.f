program textcolor
    use kernel32
    implicit none
    integer(HANDLE) :: hConsole
    integer(BOOL) :: q
    type(T_CONSOLE_SCREEN_BUFFER_INFO) :: csbi

    hConsole = GetStdHandle(STD_OUTPUT_HANDLE)

    if (GetConsoleScreenBufferInfo(hConsole, csbi) == 0) then
        error stop "GetConsoleScreenBufferInfo failed."
    end if

    q = SetConsoleTextAttribute(hConsole, int(FOREGROUND_RED .or. &
                                              FOREGROUND_INTENSITY .or. &
                                              BACKGROUND_BLUE .or. &
                                              BACKGROUND_RED, WORD))
    print "(A)", "This is a red string."
    q = SetConsoleTextAttribute(hConsole, csbi%wAttributes)
end program
