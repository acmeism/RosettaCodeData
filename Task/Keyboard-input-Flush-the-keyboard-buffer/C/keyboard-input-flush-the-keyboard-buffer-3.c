#include <conio.h>
#include <tchar.h>

// Uses only CRT functions. No need to include 'Windows.h'.

void Kbflush(void)
{
    while (_kbhit())
    {
        // The _gettch function reads a single character without echoing it. When reading
        // a function key or an arrow key, it must be called twice; the first call returns
        // 0x00 or 0xE0 and the second call returns the actual key code. Source: MSDN.
        int ch = _gettch();
        if (ch == 0x00 || ch == 0xE0)
            (void)_gettch();
    }
}

int _tmain(void)
{
    Kbflush();
    return 0;
}
