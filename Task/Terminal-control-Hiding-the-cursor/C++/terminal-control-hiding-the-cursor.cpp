#include <Windows.h>
int main()
{
  bool showCursor = false;

  HANDLE std_out = GetStdHandle(STD_OUTPUT_HANDLE); // Get standard output
  CONSOLE_CURSOR_INFO cursorInfo;                   //
  GetConsoleCursorInfo(out, &cursorInfo);           // Get cursorinfo from output
  cursorInfo.bVisible = showCursor;                 // Set flag visible.
  SetConsoleCursorInfo(out, &cursorInfo);           // Apply changes
}
