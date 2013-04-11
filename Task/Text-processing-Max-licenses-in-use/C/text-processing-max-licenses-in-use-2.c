#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <err.h>
#include <string.h>

int main()
{
	struct stat s;
	int fd = open("mlijobs.txt", O_RDONLY);
	int cnt, max_cnt, occur;
	char *buf, *ptr;

	if (fd == -1) err(1, "open");
	fstat(fd, &s);
	ptr = buf = mmap(0, s.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);

	cnt = max_cnt = 0;
	while(ptr - buf < s.st_size - 33) {
		if (!strncmp(ptr, "License OUT", 11) && ++cnt >= max_cnt) {
			if (cnt > max_cnt) {
				max_cnt = cnt;
				occur = 0;
			}
			/* can't sprintf time stamp: might overlap */
			memmove(buf + 26 * occur, ptr + 14, 19);
			sprintf(buf + 26 * occur + 19, "%6d\n", cnt);
			occur++;
		} else if (!strncmp(ptr, "License IN ", 11)) cnt --;

		while (ptr < buf + s.st_size && *ptr++ != '\n');
	}

	printf(buf);
	munmap(buf, s.st_size);
	return close(fd);
}
