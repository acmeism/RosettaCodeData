#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <syslog.h>
#include <time.h>
#include <unistd.h>

int
main(int argc, char **argv)
{
	extern char *__progname;
	time_t clock;
	int fd;

	if (argc != 2) {
		fprintf(stderr, "usage: %s file\n", __progname);
		exit(1);
	}

	/* Open the file before becoming a daemon. */
	fd = open(argv[1], O_WRONLY | O_APPEND | O_CREAT, 0666);
	if (fd < 0)
		err(1, argv[1]);

	/*
	 * Become a daemon. Lose terminal, current working directory,
	 * stdin, stdout, stderr.
	 */
	if (daemon(0, 0) < 0)
		err(1, "daemon");

	/* Redirect stdout. */
	if (dup2(fd, STDOUT_FILENO) < 0) {
		syslog(LOG_ERR, "dup2: %s", strerror(errno));
		exit(1);
	}
	close(fd);

	/* Dump clock. */
	for (;;) {
		time(&clock);
		fputs(ctime(&clock), stdout);
		if (fflush(stdout) == EOF) {
			syslog(LOG_ERR, "%s: %s", argv[1], strerror(errno));
			exit(1);
		}
		sleep(1);	/* Can wake early or drift late. */
	}
}
