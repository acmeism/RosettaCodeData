#include <windows.h>
#include <stdio.h>
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
dotruncate(wchar_t *fn, LARGE_INTEGER fp)
{
	HANDLE fh;

	fh = CreateFileW(fn, GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);
	if (fh == INVALID_HANDLE_VALUE) {
		oops(fn);
		return 1;
	}

	if (SetFilePointerEx(fh, fp, NULL, FILE_BEGIN) == 0 ||
	    SetEndOfFile(fh) == 0) {
		oops(fn);
		CloseHandle(fh);
		return 1;
	}

	CloseHandle(fh);
	return 0;
}

/*
 * Truncate or extend a file to the given length.
 */
int
main()
{
	LARGE_INTEGER fp;
	int argc;
	wchar_t **argv, *fn, junk[2];

	/* MinGW never provides wmain(argc, argv). */
	argv = CommandLineToArgvW(GetCommandLineW(), &argc);
	if (argv == NULL) {
		oops(L"CommandLineToArgvW");
		return 1;
	}

	if (argc != 3) {
		fwprintf(stderr, L"usage: %ls filename length\n", argv[0]);
		return 1;
	}

	fn = argv[1];

	/* fp = argv[2] converted to a LARGE_INTEGER. */
	if (swscanf(argv[2], L"%lld%1ls", &fp.QuadPart, &junk) != 1) {
		fwprintf(stderr, L"%ls: not a number\n", argv[2]);
		return 1;
	}

	return dotruncate(fn, fp);
}
