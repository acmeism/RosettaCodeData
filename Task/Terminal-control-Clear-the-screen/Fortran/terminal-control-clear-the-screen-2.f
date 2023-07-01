program clear
    use kernel32
    implicit none
    integer(HANDLE) :: hStdout
    hStdout = GetStdHandle(STD_OUTPUT_HANDLE)
    call clear_console(hStdout)
contains
    subroutine clear_console(hConsole)
        integer(HANDLE) :: hConsole
        type(T_COORD) :: coordScreen = T_COORD(0, 0)
        integer(DWORD) :: cCharsWritten
        type(T_CONSOLE_SCREEN_BUFFER_INFO) :: csbi
        integer(DWORD) :: dwConSize

        if (GetConsoleScreenBufferInfo(hConsole, csbi) == 0) return
        dwConSize = csbi%dwSize%X * csbi%dwSize%Y

        if (FillConsoleOutputCharacter(hConsole, SCHAR_" ", dwConSize, &
            coordScreen, loc(cCharsWritten)) == 0) return

        if (GetConsoleScreenBufferInfo(hConsole, csbi) == 0) return

        if (FillConsoleOutputAttribute(hConsole, csbi%wAttributes, &
            dwConSize, coordScreen, loc(cCharsWritten)) == 0) return

        if (SetConsoleCursorPosition(hConsole, coordScreen) == 0) return
    end subroutine
end program
