#include <windows.h>
#include <stdio.h>

int main(void) {
    HANDLE hFile;

    hFile = CreateFile("output.txt", GENERIC_WRITE, 0, NULL,
                       CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE) {
        printf("Unable to create file\n");
    } else {
        CloseHandle(hFile);
    }

    if (CreateDirectory("docs", NULL) == 0) {
        printf("Unable to create directory\n");
    }

    hFile = CreateFile("\\output.txt", GENERIC_WRITE, 0, NULL,
                       CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE) {
        printf("Unable to create file\n");
    } else {
        CloseHandle(hFile);
    }

    if (CreateDirectory("\\docs", NULL) == 0) {
        printf("Unable to create directory\n");
    }

    return 0;
}
