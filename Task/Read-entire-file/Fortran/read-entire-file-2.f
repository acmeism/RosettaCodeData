program file_win
    use kernel32
    use iso_c_binding
    implicit none

    integer(HANDLE) :: hFile, hMap, hOutput
    integer(DWORD) :: fileSize
    integer(LPVOID) :: ptr
    integer(LPDWORD) :: charsWritten
    integer(BOOL) :: s

    hFile = CreateFile("file_win.f90" // c_null_char, GENERIC_READ, &
                       0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
    filesize = GetFileSize(hFile, NULL)
    hMap = CreateFileMapping(hFile, NULL, PAGE_READONLY, 0, 0, NULL)
    ptr = MapViewOfFile(hMap, FILE_MAP_READ, 0, 0, 0)

    hOutput = GetStdHandle(STD_OUTPUT_HANDLE)
    s = WriteConsole(hOutput, ptr, fileSize, transfer(c_loc(charsWritten), 0_c_intptr_t), NULL)
    s = CloseHandle(hMap)
    s = CloseHandle(hFile)
end program
