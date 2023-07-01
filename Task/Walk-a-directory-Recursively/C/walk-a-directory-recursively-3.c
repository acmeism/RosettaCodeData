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

/*
 * Print all files in a given directory tree that match a given wildcard
 * pattern.
 */
int
main()
{
	struct stack {
		wchar_t			*path;
		size_t			 pathlen;
		size_t			 slashlen;
		HANDLE			 ffh;
		WIN32_FIND_DATAW	 ffd;
		struct stack		*next;
	} *dir, dir0, *ndir;
	size_t patternlen;
	int argc;
	wchar_t **argv, *buf, c, *pattern;

	/* MinGW never provides wmain(argc, argv). */
	argv = CommandLineToArgvW(GetCommandLineW(), &argc);
	if (argv == NULL) {
		oops(L"CommandLineToArgvW");
		exit(1);
	}

	if (argc != 3) {
		fwprintf(stderr, L"usage: %ls dir pattern\n", argv[0]);
		exit(1);
	}

	dir0.path = argv[1];
	dir0.pathlen = wcslen(dir0.path);
	pattern = argv[2];
	patternlen = wcslen(pattern);

	if (patternlen == 0 ||
	    wcscmp(pattern, L".") == 0 ||
	    wcscmp(pattern, L"..") == 0 ||
	    wcschr(pattern, L'/') ||
	    wcschr(pattern, L'\\')) {
		fwprintf(stderr, L"%ls: invalid pattern\n", pattern);
		exit(1);
	}

	/*
	 * Must put backslash between path and pattern, unless
	 * last character of path is slash or colon.
	 *
	 *   'dir' => 'dir\*'
	 *   'dir\' => 'dir\*'
	 *   'dir/' => 'dir/*'
	 *   'c:' => 'c:*'
	 *
	 * 'c:*' and 'c:\*' are different files!
	 */
	c = dir0.path[dir0.pathlen - 1];
	if (c == ':' || c == '/' || c == '\\')
		dir0.slashlen = dir0.pathlen;
	else
		dir0.slashlen = dir0.pathlen + 1;

	/* Allocate space for path + backslash + pattern + \0. */
	buf = calloc(dir0.slashlen + patternlen + 1, sizeof buf[0]);
	if (buf == NULL) {
		perror("calloc");
		exit(1);
	}
	dir0.path = wmemcpy(buf, dir0.path, dir0.pathlen + 1);

	dir0.ffh = INVALID_HANDLE_VALUE;
	dir0.next = NULL;
	dir = &dir0;

	/* Loop for each directory in linked list. */
loop:
	while (dir) {
		/*
		 * At first visit to directory:
		 *   Print the matching files. Then, begin to find
		 *   subdirectories.
		 *
		 * At later visit:
		 *   dir->ffh is the handle to find subdirectories.
		 *   Continue to find them.
		 */
		if (dir->ffh == INVALID_HANDLE_VALUE) {
			/* Append backslash + pattern + \0 to path. */
			dir->path[dir->pathlen] = '\\';
			wmemcpy(dir->path + dir->slashlen,
			    pattern, patternlen + 1);

			/* Find all files to match pattern. */
			dir->ffh = FindFirstFileW(dir->path, &dir->ffd);
			if (dir->ffh == INVALID_HANDLE_VALUE) {
				/* Check if no files match pattern. */
				if (GetLastError() == ERROR_FILE_NOT_FOUND)
					goto subdirs;

				/* Bail out from other errors. */
				dir->path[dir->pathlen] = '\0';
				oops(dir->path);
				goto popdir;
			}

			/* Remove pattern from path; keep backslash. */
			dir->path[dir->slashlen] = '\0';

			/* Print all files to match pattern. */
			do {
				wprintf(L"%ls%ls\n",
				    dir->path, dir->ffd.cFileName);
			} while (FindNextFileW(dir->ffh, &dir->ffd) != 0);
			if (GetLastError() != ERROR_NO_MORE_FILES) {
				dir->path[dir->pathlen] = '\0';
				oops(dir->path);
			}
			FindClose(dir->ffh);

subdirs:
			/* Append * + \0 to path. */
			dir->path[dir->slashlen] = '*';
			dir->path[dir->slashlen + 1] = '\0';

			/* Find first possible subdirectory. */
			dir->ffh = FindFirstFileExW(dir->path,
			    FindExInfoStandard, &dir->ffd,
			    FindExSearchLimitToDirectories, NULL, 0);
			if (dir->ffh == INVALID_HANDLE_VALUE) {
				dir->path[dir->pathlen] = '\0';
				oops(dir->path);
				goto popdir;
			}
		} else {
			/* Find next possible subdirectory. */
			if (FindNextFileW(dir->ffh, &dir->ffd) == 0)
				goto closeffh;				
		}

		/* Enter subdirectories. */
		do {
			const wchar_t *fn = dir->ffd.cFileName;
			const DWORD attr = dir->ffd.dwFileAttributes;
			size_t buflen, fnlen;

			/*
			 * Skip '.' and '..', because they are links to
			 * the current and parent directories, so they
			 * are not subdirectories.
			 *
			 * Skip any file that is not a directory.
			 *
			 * Skip all reparse points, because they might
			 * be symbolic links. They might form a cycle,
			 * with a directory inside itself.
			 */
			if (wcscmp(fn, L".") == 0 ||
			    wcscmp(fn, L"..") == 0 ||
			    (attr & FILE_ATTRIBUTE_DIRECTORY) == 0 ||
			    (attr & FILE_ATTRIBUTE_REPARSE_POINT))
				continue;

			ndir = malloc(sizeof *ndir);
			if (ndir == NULL) {
				perror("malloc");
				exit(1);
			}

			/*
			 * Allocate space for path + backslash +
			 *     fn + backslash + pattern + \0.
			 */
			fnlen = wcslen(fn);
			buflen = dir->slashlen + fnlen + patternlen + 2;
			buf = calloc(buflen, sizeof buf[0]);
			if (buf == NULL) {
				perror("malloc");
				exit(1);
			}

			/* Copy path + backslash + fn + \0. */
			wmemcpy(buf, dir->path, dir->slashlen);
			wmemcpy(buf + dir->slashlen, fn, fnlen + 1);

			/* Push dir to list. Enter dir. */
			ndir->path = buf;
			ndir->pathlen = dir->slashlen + fnlen;
			ndir->slashlen = ndir->pathlen + 1;
			ndir->ffh = INVALID_HANDLE_VALUE;
			ndir->next = dir;
			dir = ndir;
			goto loop; /* Continue outer loop. */
		} while (FindNextFileW(dir->ffh, &dir->ffd) != 0);
closeffh:
		if (GetLastError() != ERROR_NO_MORE_FILES) {
			dir->path[dir->pathlen] = '\0';
			oops(dir->path);
		}
		FindClose(dir->ffh);

popdir:
		/* Pop dir from list, free dir, but never free dir0. */
		free(dir->path);
		if (ndir = dir->next)
			free(dir);
		dir = ndir;
	}

	return 0;
}
