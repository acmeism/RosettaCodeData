#include <sys/stat.h>
#include <stdio.h>
#include <time.h>
#include <utime.h>

const char *filename = "input.txt";

int main() {
  struct stat foo;
  time_t mtime;
  struct utimbuf new_times;

  if (stat(filename, &foo) < 0) {
    perror(filename);
    return 1;
  }
  mtime = foo.st_mtime; /* seconds since the epoch */

  new_times.actime = foo.st_atime; /* keep atime unchanged */
  new_times.modtime = time(NULL);    /* set mtime to current time */
  if (utime(filename, &new_times) < 0) {
    perror(filename);
    return 1;
  }

  return 0;
}
