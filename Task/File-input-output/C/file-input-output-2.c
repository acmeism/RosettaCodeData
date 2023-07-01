#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

/* we just return a yes/no status; caller can check errno */
int copy_file(const char *in, const char *out)
{
	int ret = 0;
	int fin, fout;
	ssize_t len;
	char *buf[4096]; /* buffer size, some multiple of block size preferred */
	struct stat st;

	if ((fin  = open(in,  O_RDONLY)) == -1) return 0;
	if (fstat(fin, &st)) goto bail;

	/* open output with same permission */
	fout = open(out, O_WRONLY|O_CREAT|O_TRUNC, st.st_mode & 0777);
	if (fout == -1) goto bail;

	while ((len = read(fin, buf, 4096)) > 0)
		write(fout, buf, len);

	ret = len ? 0 : 1; /* last read should be 0 */

bail:	if (fin != -1)  close(fin);
	if (fout != -1) close(fout);
	return ret;
}

int main()
{
	copy_file("infile", "outfile");
	return 0;
}
