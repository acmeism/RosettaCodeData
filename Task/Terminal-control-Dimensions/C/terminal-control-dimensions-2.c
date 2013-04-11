#include <windows.h>
#include <wchar.h>

int
main()
{
	HANDLE console;
	CONSOLE_SCREEN_BUFFER_INFO info;
	short rows;
	short columns;
	/* Create a handle to the console screen. */
	console = CreateFileW(L"CONOUT$", GENERIC_READ | GENERIC_WRITE,
	    FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING,
	    0, NULL);
	if (console == INVALID_HANDLE_VALUE)
		return 1;

	/* Calculate the size of the console window. */
	if (GetConsoleScreenBufferInfo(console, &info) == 0)
		return 1;
	CloseHandle(console);
	columns = info.srWindow.Right - info.srWindow.Left + 1;
	rows = info.srWindow.Bottom - info.srWindow.Top + 1;

	wprintf(L"%d columns by %d rows\n", columns, rows);

	return 0;
}
