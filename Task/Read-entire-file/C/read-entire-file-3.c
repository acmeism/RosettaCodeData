#include <windows.h>
#include <stdio.h>

int main() {
    HANDLE hFile, hMap;
    DWORD filesize;
    char *p;

    hFile = CreateFile("mmap_win.c", GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    filesize = GetFileSize(hFile, NULL);
    hMap = CreateFileMapping(hFile, NULL, PAGE_READONLY, 0, 0, NULL);
    p = MapViewOfFile(hMap, FILE_MAP_READ, 0, 0, 0);

    fwrite(p, filesize, 1, stdout);

    CloseHandle(hMap);
    CloseHandle(hFile);
    return 0;
}
