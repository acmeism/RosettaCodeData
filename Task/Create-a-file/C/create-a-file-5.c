#include <os2.h>

int main(void) {
    ULONG Result, ActionTaken, hFile;

    Result = DosOpen("output.txt", &hFile, &ActionTaken, 0L,
                     FILE_NORMAL,
                     OPEN_ACTION_REPLACE_IF_EXISTS | OPEN_ACTION_CREATE_IF_NEW,
                     OPEN_ACCESS_WRITEONLY | OPEN_SHARE_DENYREADWRITE,
                     NULL);
    if (Result != 0) {
        printf("Unable to create file\n");
    } else {
        DosClose(hFile);
    }

    Result = DosMkDir("docs", NULL);
    if (Result != 0) {
        printf("Unable to create directory\n");
    }

    Result = DosOpen("\\output.txt", &hFile, &ActionTaken, 0L,
                     FILE_NORMAL,
                     OPEN_ACTION_REPLACE_IF_EXISTS | OPEN_ACTION_CREATE_IF_NEW,
                     OPEN_ACCESS_WRITEONLY | OPEN_SHARE_DENYREADWRITE,
                     NULL);
    if (Result != 0) {
        printf("Unable to create file\n");
    } else {
        DosClose(hFile);
    }

    Result = DosMkDir("\\docs", NULL);
    if (Result != 0) {
        printf("Unable to create directory\n");
    }

    return 0;
}
