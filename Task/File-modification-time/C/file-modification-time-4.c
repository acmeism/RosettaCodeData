#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>

/* Print "message: last Win32 error" to stderr. */
void
oops(const wchar_t *message)
{
	wchar_t *buf;
	DWORD error;

	buf = NULL;
	error = GetLastError();
	FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER |
	    FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
	    NULL, error, 0, (wchar_t *)&buf, 0, NULL);

	if (buf) {
		fwprintf(stderr, L"%ls: %ls", message, buf);
		LocalFree(buf);
	} else {
		/* FormatMessageW failed. */
		fwprintf(stderr, L"%ls: unknown error 0x%x\n",
		    message, error);
	}
}

int
setmodtime(const wchar_t *path)
{
	FILETIME modtime;
	SYSTEMTIME st;
	HANDLE fh;
	wchar_t date[80], time[80];

	fh = CreateFileW(path, GENERIC_READ | FILE_WRITE_ATTRIBUTES,
	    0, NULL, OPEN_EXISTING, 0, NULL);
	if (fh == INVALID_HANDLE_VALUE) {
		oops(path);
		return 1;
	}

	/*
	 * Use GetFileTime() to get the file modification time.
	 */
	if (GetFileTime(fh, NULL, NULL, &modtime) == 0)
		goto fail;
	FileTimeToSystemTime(&modtime, &st);
	if (GetDateFormatW(LOCALE_USER_DEFAULT, DATE_LONGDATE, &st, NULL,
	    date, sizeof date / sizeof date[0]) == 0 ||
	    GetTimeFormatW(LOCALE_USER_DEFAULT, 0, &st, NULL,
	    time, sizeof time / sizeof time[0]) == 0)
		goto fail;
	wprintf(L"%ls: Last modified at %s at %s (UTC).\n",
	    path, date, time);

	/*
	 * Use SetFileTime() to change the file modification time
	 * to the current time.
	 */
	GetSystemTime(&st);
	if (GetDateFormatW(LOCALE_USER_DEFAULT, DATE_LONGDATE, &st, NULL,
	    date, sizeof date / sizeof date[0]) == 0 ||
	    GetTimeFormatW(LOCALE_USER_DEFAULT, 0, &st, NULL,
	    time, sizeof time / sizeof time[0]) == 0)
		goto fail;
	SystemTimeToFileTime(&st, &modtime);
	if (SetFileTime(fh, NULL, NULL, &modtime) == 0)
		goto fail;
	wprintf(L"%ls: Changed to %s at %s (UTC).\n", path, date, time);

	CloseHandle(fh);
	return 0;

fail:
	oops(path);
	CloseHandle(fh);
	return 1;
}

/*
 * Show the file modification time, and change it to the current time.
 */
int
main()
{
	int argc, i, r;
	wchar_t **argv;

	/* MinGW never provides wmain(argc, argv). */
	argv = CommandLineToArgvW(GetCommandLineW(), &argc);
	if (argv == NULL) {
		oops(L"CommandLineToArgvW");
		exit(1);
	}

	if (argc < 2) {
		fwprintf(stderr, L"usage: %ls file...\n", argv[0]);
		exit(1);
	}

	r = 0;
	for (i = 1; argv[i] != NULL; i++)
		if (setmodtime(argv[i])) r = 1;
	return r;
}
