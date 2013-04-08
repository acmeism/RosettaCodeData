#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <err.h>
#include <string.h>

int ordered(char *s, char **end)
{
	int r = 1;
	while (*++s != '\n' && *s != '\r' && *s != '\0')
		if (s[0] < s[-1]) r = 0;

	*end = s;
	return r;
}

int main()
{
	char *buf, *word, *end, *tail;
	struct stat st;
	int longest = 0, len, fd;

	if ((fd = open("unixdict.txt", O_RDONLY)) == -1) err(1, "read error");

	fstat(fd, &st);
	if (!(buf = mmap(0, st.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0)))
		err(1, "mmap");

	for (word = end = buf; end < buf + st.st_size; word = end) {
		while (*word == '\r' || *word == '\n') word++;
		if (!ordered(word, &end)) continue;
		if ((len = end - word + 1) < longest) continue;
		if (len > longest) {
			tail = buf;  /* longer words found; reset out buffer */
			longest = len;
		}
		/* use the same mmap'd region to store output.  because of MAP_PRIVATE,
		 * change will not go back to file.  mmap is copy on write, and we are using
		 * only the head space to store output, so kernel doesn't need to copy more
		 * than the words we saved--in this case, one page tops.
		 */
		memcpy(tail, word, len);
		tail += len;
		*tail = '\0';
	}
	printf(buf);

	munmap(buf, st.st_size);
	close(fd);
	return 0;
}
