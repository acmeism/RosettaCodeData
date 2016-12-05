module kernel32
    use iso_c_binding
    implicit none
    integer, parameter :: HANDLE = C_INTPTR_T
    integer, parameter :: PVOID = C_INTPTR_T
    integer, parameter :: LPDWORD = C_INTPTR_T
    integer, parameter :: BOOL = C_INT
    integer, parameter :: SHORT = C_INT16_T
    integer, parameter :: WORD = C_INT16_T
    integer, parameter :: DWORD = C_INT32_T
    integer, parameter :: SCHAR = C_CHAR
    integer(DWORD), parameter :: STD_INPUT_HANDLE = -10
    integer(DWORD), parameter :: STD_OUTPUT_HANDLE = -11
    integer(DWORD), parameter :: STD_ERROR_HANDLE = -12

    type, bind(C) :: T_COORD
        integer(SHORT) :: X, Y
    end type

    type, bind(C) :: T_SMALL_RECT
        integer(SHORT) :: Left
        integer(SHORT) :: Top
        integer(SHORT) :: Right
        integer(SHORT) :: Bottom
    end type

    type, bind(C) :: T_CONSOLE_SCREEN_BUFFER_INFO
        type(T_COORD) :: dwSize
        type(T_COORD) :: dwCursorPosition
        integer(WORD) :: wAttributes
        type(T_SMALL_RECT) :: srWindow
        type(T_COORD) :: dwMaximumWindowSize
    end type

    interface
        function FillConsoleOutputCharacter(hConsoleOutput, cCharacter, &
                nLength, dwWriteCoord, lpNumberOfCharsWritten) &
                bind(C, name="FillConsoleOutputCharacterA")
            import BOOL, C_CHAR, SCHAR, HANDLE, DWORD, T_COORD, LPDWORD
            !GCC$ ATTRIBUTES STDCALL :: FillConsoleOutputCharacter
            integer(BOOL) :: FillConsoleOutputCharacter
            integer(HANDLE), value :: hConsoleOutput
            character(kind=SCHAR), value :: cCharacter
            integer(DWORD), value :: nLength
            type(T_COORD), value :: dwWriteCoord
            integer(LPDWORD), value :: lpNumberOfCharsWritten
        end function
    end interface

    interface
        function FillConsoleOutputAttribute(hConsoleOutput, wAttribute, &
                nLength, dwWriteCoord, lpNumberOfAttrsWritten) &
                bind(C, name="FillConsoleOutputAttribute")
            import BOOL, HANDLE, WORD, DWORD, T_COORD, LPDWORD
            !GCC$ ATTRIBUTES STDCALL :: FillConsoleOutputAttribute
            integer(BOOL) :: FillConsoleOutputAttribute
            integer(HANDLE), value :: hConsoleOutput
            integer(WORD), value :: wAttribute
            integer(DWORD), value :: nLength
            type(T_COORD), value :: dwWriteCoord
            integer(LPDWORD), value :: lpNumberOfAttrsWritten
        end function
    end interface

    interface
        function GetConsoleScreenBufferInfo(hConsoleOutput, &
                lpConsoleScreenBufferInfo) &
                bind(C, name="GetConsoleScreenBufferInfo")
            import BOOL, HANDLE, T_CONSOLE_SCREEN_BUFFER_INFO
            !GCC$ ATTRIBUTES STDCALL :: GetConsoleScreenBufferInfo
            integer(BOOL) :: GetConsoleScreenBufferInfo
            integer(HANDLE), value :: hConsoleOutput
            type(T_CONSOLE_SCREEN_BUFFER_INFO) :: lpConsoleScreenBufferInfo
        end function
    end interface

    interface
        function SetConsoleCursorPosition(hConsoleOutput, dwCursorPosition) &
                bind(C, name="SetConsoleCursorPosition")
            import BOOL, HANDLE, T_COORD
            !GCC$ ATTRIBUTES STDCALL :: SetConsoleCursorPosition
            integer(BOOL) :: SetConsoleCursorPosition
            integer(HANDLE), value :: hConsoleOutput
            type(T_COORD), value :: dwCursorPosition
        end function
    end interface

    interface
        function GetStdHandle(nStdHandle) bind(C, name="GetStdHandle")
            import HANDLE, DWORD
            !GCC$ ATTRIBUTES STDCALL :: GetStdHandle
            integer(HANDLE) :: GetStdHandle
            integer(DWORD), value :: nStdHandle
        end function
    end interface
end module
