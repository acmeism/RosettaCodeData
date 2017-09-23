#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>
#include <err.h>

int read_lines(const char * fname, int (*call_back)(const char*, const char*))
{
        int fd = open(fname, O_RDONLY);
        struct stat fs;
        char *buf, *buf_end;
        char *begin, *end, c;

        if (fd == -1) {
                err(1, "open: %s", fname);
                return 0;
        }

        if (fstat(fd, &fs) == -1) {
                err(1, "stat: %s", fname);
                return 0;
        }

        /* fs.st_size could have been 0 actually */
        buf = mmap(0, fs.st_size, PROT_READ, MAP_SHARED, fd, 0);
        if (buf == (void*) -1) {
                err(1, "mmap: %s", fname);
                close(fd);
                return 0;
        }

        buf_end = buf + fs.st_size;

        begin = end = buf;
        while (1) {
                if (! (*end == '\r' || *end == '\n')) {
                        if (++end < buf_end) continue;
                } else if (1 + end < buf_end) {
                        /* see if we got "\r\n" or "\n\r" here */
                        c = *(1 + end);
                        if ( (c == '\r' || c == '\n') && c != *end)
                                ++end;
                }

                /* call the call back and check error indication. Announce
                   error here, because we didn't tell call_back the file name */
                if (! call_back(begin, end)) {
                        err(1, "[callback] %s", fname);
                        break;
                }

                if ((begin = ++end) >= buf_end)
                        break;
        }

        munmap(buf, fs.st_size);
        close(fd);
        return 1;
}

int print_line(const char* begin, const char* end)
{
        if (write(fileno(stdout), begin, end - begin + 1) == -1) {
                return 0;
        }
        return 1;
}

int main()
{
        return read_lines("test.ps", print_line) ? 0 : 1;
}
