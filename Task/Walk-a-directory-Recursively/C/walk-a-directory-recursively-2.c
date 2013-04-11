#include <sys/types.h>
#include <err.h>
#include <errno.h>
#include <fnmatch.h>
#include <fts.h>
#include <string.h>
#include <stdio.h>

/* Compare files by name. */
int
entcmp(const FTSENT **a, const FTSENT **b)
{
	return strcmp((*a)->fts_name, (*b)->fts_name);
}

/*
 * Print all files in the directory tree that match the glob pattern.
 * Example: pmatch("/usr/src", "*.c");
 */
void
pmatch(char *dir, const char *pattern)
{
	FTS *tree;
	FTSENT *f;
	char *argv[] = { dir, NULL };

	/*
	 * FTS_LOGICAL follows symbolic links, including links to other
	 * directories. It detects cycles, so we never have an infinite
	 * loop. FTS_NOSTAT is because we never use f->statp. It uses
	 * our entcmp() to sort files by name.
	 */
	tree = fts_open(argv, FTS_LOGICAL | FTS_NOSTAT, entcmp);
	if (tree == NULL)
		err(1, "fts_open");

	/*
	 * Iterate files in tree. This iteration always skips
	 * "." and ".." because we never use FTS_SEEDOT.
	 */
	while ((f = fts_read(tree))) {
		switch (f->fts_info) {
		case FTS_DNR:	/* Cannot read directory */
		case FTS_ERR:	/* Miscellaneous error */
		case FTS_NS:	/* stat() error */
			/* Show error, then continue to next files. */
			warn("%s", f->fts_path);
			continue;
		case FTS_DP:
			/* Ignore post-order visit to directory. */
			continue;
		}

		/*
		 * Check if name matches pattern. If so, then print
		 * path. This check uses FNM_PERIOD, so "*.c" will not
		 * match ".invisible.c".
		 */
		if (fnmatch(pattern, f->fts_name, FNM_PERIOD) == 0)
			puts(f->fts_path);

		/*
		 * A cycle happens when a symbolic link (or perhaps a
		 * hard link) puts a directory inside itself. Tell user
		 * when this happens.
		 */
		if (f->fts_info == FTS_DC)
			warnx("%s: cycle in directory tree", f->fts_path);
	}

	/* fts_read() sets errno = 0 unless it has error. */
	if (errno != 0)
		err(1, "fts_read");

	if (fts_close(tree) < 0)
		err(1, "fts_close");
}

int
main()
{
	pmatch(".", "*.c");
	return 0;
}
