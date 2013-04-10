#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

int main() { /* permissions are before umask */
  int fd = open("output.txt", O_WRONLY|O_CREAT|O_TRUNC, 0640); /* rights 0640 for rw-r----- */
  /* or equivalently:
     int fd = creat("output.txt", 0640); */ /* rights 0640 for rw-r----- */
  close(fd);

  mkdir("docs", 0750); /* rights 0750 for rwxr-x--- */

  return 0;
}
