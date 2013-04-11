#include <sys/ioctl.h>	/* ioctl, TIOCGWINSZ */
#include <err.h>	/* err */
#include <fcntl.h>	/* open */
#include <stdio.h>	/* printf */
#include <unistd.h>	/* close */

int
main()
{
	struct winsize ws;
	int fd;

	/* Open the controlling terminal. */
	fd = open("/dev/tty", O_RDWR);
	if (fd < 0)
		err(1, "/dev/tty");

	/* Get window size of terminal. */
	if (ioctl(fd, TIOCGWINSZ, &ws) < 0)
		err(1, "/dev/tty");

	printf("%d rows by %d columns\n", ws.ws_row, ws.ws_col);
	printf("(%d by %d pixels)\n", ws.ws_xpixel, ws.ws_ypixel);

	close(fd);	
	return 0;
}
