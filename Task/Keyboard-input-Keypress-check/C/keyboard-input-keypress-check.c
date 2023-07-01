#include <stdio.h>
#include <termios.h>  /* general terminal interface: tcgetattr, tcsetattr, tcflush */
#include <unistd.h>   /* synchronous I/O multiplexing: select, FD_CLR, FD_ISSET, FD_SET, FD_ZERO */
#include <fcntl.h>

void set_mode(int want_key)
{
	static struct termios old, new;
	if (!want_key) {
		tcsetattr(STDIN_FILENO, TCSANOW, &old);
		return;
	}

	tcgetattr(STDIN_FILENO, &old);
	new = old;
	new.c_lflag &= ~(ICANON | ECHO);
	tcsetattr(STDIN_FILENO, TCSANOW, &new);
}

int get_key()
{
	int c = 0;
	struct timeval tv;
	fd_set fs;
	tv.tv_usec = tv.tv_sec = 0;

	FD_ZERO(&fs);
	FD_SET(STDIN_FILENO, &fs);
	select(STDIN_FILENO + 1, &fs, 0, 0, &tv);

	if (FD_ISSET(STDIN_FILENO, &fs)) {
		c = getchar();
		set_mode(0);
	}
	return c;
}

int main()
{
	int c;
	while(1) {
		set_mode(1);
                /* force C library buffers to be written to kernel buffers,
                   and flush pending input to avoid previously pressed keys */
                fflush(stdout);
		while (!(c = get_key())) usleep(10000);
		printf("key %d\n", c);
	}
}
