#include <fcntl.h>	/* fcntl, open */
#include <stdlib.h>	/* atexit, getenv, malloc */
#include <stdio.h>	/* fputs, printf, puts, snprintf */
#include <string.h>	/* memcpy */
#include <unistd.h>	/* sleep, unlink */

/* Filename for only_one_instance() lock. */
#define INSTANCE_LOCK "rosetta-code-lock"

void
fail(const char *message)
{
	perror(message);
	exit(1);
}

/* Path to only_one_instance() lock. */
static char *ooi_path;

void
ooi_unlink(void)
{
	unlink(ooi_path);
}

/* Exit if another instance of this program is running. */
void
only_one_instance(void)
{
	struct flock fl;
	size_t dirlen;
	int fd;
	char *dir;

	/*
	 * Place the lock in the home directory of this user;
	 * therefore we only check for other instances by the same
	 * user (and the user can trick us by changing HOME).
	 */
	dir = getenv("HOME");
	if (dir == NULL || dir[0] != '/') {
		fputs("Bad home directory.\n", stderr);
		exit(1);
	}
	dirlen = strlen(dir);

	ooi_path = malloc(dirlen + sizeof("/" INSTANCE_LOCK));
	if (ooi_path == NULL)
		fail("malloc");
	memcpy(ooi_path, dir, dirlen);
	memcpy(ooi_path + dirlen, "/" INSTANCE_LOCK,
	    sizeof("/" INSTANCE_LOCK));  /* copies '\0' */

	fd = open(ooi_path, O_RDWR | O_CREAT, 0600);
	if (fd < 0)
		fail(ooi_path);

	fl.l_start = 0;
	fl.l_len = 0;
	fl.l_type = F_WRLCK;
	fl.l_whence = SEEK_SET;
	if (fcntl(fd, F_SETLK, &fl) < 0) {
		fputs("Another instance of this program is running.\n",
		    stderr);
		exit(1);
	}

	/*
	 * Run unlink(ooi_path) when the program exits. The program
	 * always releases locks when it exits.
	 */
	atexit(ooi_unlink);
}

/*
 * Demo for Rosetta Code.
 * http://rosettacode.org/wiki/Determine_if_only_one_instance_is_running
 */
int
main()
{
	int i;

	only_one_instance();

	/* Play for 10 seconds. */
	for(i = 10; i > 0; i--) {
		printf("%d...%s", i, i % 5 == 1 ? "\n" : " ");
		fflush(stdout);
		sleep(1);
	}
	puts("Fin!");
	return 0;
}
