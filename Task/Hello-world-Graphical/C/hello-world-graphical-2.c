#include "windows.h"
void SayGoodbyeWorld(HWND hWnd)
{
  SetWindowText(hWnd, _T("Goodbye, World!"));
}
