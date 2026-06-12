#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <limits.h>
#include <pthread.h>

/* Flag for systems where a blocking open on a pipe will block
   entire process instead of just current thread.  Ideally this
   kind of flags should be automatically probed, but not before
   we are sure about how each OS behaves.  It can be set to 1
   even if not needed to, but that would force polling, which I'd
   rather not do.
     Linux:	won't block all threads (0)
     OpenBSD:	will block all (1)
   Other OSes: ?
*/

#define WILL_BLOCK_EVERYTHING	0

#if WILL_BLOCK_EVERYTHING
#include <poll.h>
#endif

size_t tally = 0;

void* write_loop(void *a)
{
	int fd;
	char buf[32];
	while (1) {
#if WILL_BLOCK_EVERYTHING
		/* try to open non-block. sleep and retry if no reader */
		fd = open("out", O_WRONLY|O_NONBLOCK);
		if (fd < 0) { /* assume it's ENXIO, "no reader" */
			usleep(200000);
			continue;
		}
#else
		/* block open, until a reader comes along */
		fd = open("out", O_WRONLY);
#endif
		write(fd, buf, snprintf(buf, 32, "%d\n", tally));
		close(fd);

		/* Give the reader a chance to go away. We yeild, OS signals
		   reader end of input, reader leaves. If a new reader comes
		   along while we sleep, it will block wait. */
		usleep(10000);
	}
}

void read_loop()
{
	int fd;
	size_t len;
	char buf[PIPE_BUF];
#if WILL_BLOCK_EVERYTHING
	struct pollfd pfd;
	pfd.events = POLLIN;
#endif
	while (1) {
#if WILL_BLOCK_EVERYTHING
		fd = pfd.fd = open("in", O_RDONLY|O_NONBLOCK);
		fcntl(fd, F_SETFL, 0);  /* disable O_NONBLOCK */
		poll(&pfd, 1, INFTIM);  /* poll to avoid reading EOF */
#else
		fd = open("in", O_RDONLY);
#endif
		while ((len = read(fd, buf, PIPE_BUF)) > 0) tally += len;
		close(fd);
	}
}

int main()
{
	pthread_t pid;

	/* haphazardly create the fifos.  It's ok if the fifos already exist,
	   but things won't work out if the files exist but are not fifos;
	   if we don't have write permission; if we are on NFS; etc.  Just
	   pretend it works. */
	mkfifo("in", 0666);
	mkfifo("out", 0666);

	/* because of blocking on open O_WRONLY, can't select */
	pthread_create(&pid, 0, write_loop, 0);
	read_loop();

	return 0;
}
