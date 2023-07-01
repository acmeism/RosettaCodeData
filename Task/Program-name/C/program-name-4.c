#include <windows.h>
#include <stdlib.h>
#include <wchar.h>

/*
 * Returns the path to the current executable file, in a newly
 * allocated buffer. Use free() to free it.
 */
wchar_t *
exepath(void)
{
	wchar_t *buf, *newbuf;
	long blen, flen;

	/*
	 * Most paths fit in MAX_PATH == 260 characters, but very
	 * long UNC paths might require a larger buffer.
	 */
	buf = NULL;
	for (blen = MAX_PATH; 1; blen += MAX_PATH) {
		/* Enlarge buffer. */
		newbuf = realloc(buf, blen * sizeof buf[0]);
		if (newbuf == NULL) {
			free(buf);
			return NULL;
		}
		buf = newbuf;

		flen = GetModuleFileNameW(NULL, buf, blen);
		if (flen == 0) {
			free(buf);
			return NULL;
		}
		if (flen < blen)
			return buf;
	}
}

/*
 * Print the path to this executable.
 */
int
main()
{
	wchar_t *path;

	path = exepath();
	if (path == NULL) {
		wprintf(L"Sorry, an error occured.\n");
		return 1;
	}

	wprintf(L"Path to executable: %ls\n", path);

	free(path);
	return 0;
}
