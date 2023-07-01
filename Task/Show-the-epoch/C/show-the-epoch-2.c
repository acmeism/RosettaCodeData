#include <windows.h>
#include <stdio.h>
#include <wchar.h>

int
main()
{
	FILETIME ft = {dwLowDateTime: 0, dwHighDateTime: 0};  /* Epoch */
	SYSTEMTIME st;
	wchar_t date[80], time[80];

	/*
	 * Convert FILETIME (which counts 100-nanosecond intervals since
	 * the epoch) to SYSTEMTIME (which has year, month, and so on).
	 *
	 * The time is in UTC, because we never call
	 * SystemTimeToTzSpecificLocalTime() to convert it to local time.
	 */
	FileTimeToSystemTime(&ft, &st);

	/*
	 * Format SYSTEMTIME as a string.
	 */
	if (GetDateFormatW(LOCALE_USER_DEFAULT, DATE_LONGDATE, &st, NULL,
	    date, sizeof date / sizeof date[0]) == 0 ||
	    GetTimeFormatW(LOCALE_USER_DEFAULT, 0, &st, NULL,
	    time, sizeof time / sizeof time[0]) == 0) {
		fwprintf(stderr, L"Error!\n");
		return 1;
	}

	wprintf(L"FileTime epoch is %ls, at %ls (UTC).\n", date, time);
	return 0;
}
