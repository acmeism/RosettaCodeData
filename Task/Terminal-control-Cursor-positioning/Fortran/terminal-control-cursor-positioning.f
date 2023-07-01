program textposition
    use kernel32
    implicit none
    integer(HANDLE) :: hConsole
    integer(BOOL) :: q

    hConsole = GetStdHandle(STD_OUTPUT_HANDLE)
    q = SetConsoleCursorPosition(hConsole, T_COORD(3, 6))
    q = WriteConsole(hConsole, loc("Hello"), 5, NULL, NULL)
end program
