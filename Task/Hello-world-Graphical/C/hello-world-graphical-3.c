#include <os2.h>

int main(void) {
    HAB hab;
    HMQ hmq;

    hab = WinInitialize(0);
    hmq = WinCreateMsgQueue(hab, 0);

    WinMessageBox(HWND_DESKTOP,
                  HWND_DESKTOP,
                  "Hello, Presentation Manager!",
                  "My Program",
                  0L,
                  0L);

    WinDestroyMsgQueue(hmq);
    WinTerminate(hab);
    return 0;
}
