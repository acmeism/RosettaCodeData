#include <Windows.h>

COLORREF getColorAtCursor(void) {
    POINT p;
    COLORREF color;
    HDC hDC;
    BOOL b;

    /* Get the device context for the screen */
    hDC = GetDC(NULL);
    if (hDC == NULL)
        return CLR_INVALID;

    /* Get the current cursor position */
    b = GetCursorPos(&p);
    if (!b)
        return CLR_INVALID;

    /* Retrieve the color at that position */
    color = GetPixel(hDC, p.x, p.y);

    /* Release the device context again */
    ReleaseDC(GetDesktopWindow(), hDC);

    return color;
}
