#include <sys/stat.h>
#include <sys/time.h>
#include <time.h>
#include <fcntl.h>
#include <stdio.h>

const char *filename = "input.txt";

int main() {
  struct stat foo;
  struct timespec new_times[2];

  if (stat(filename, &foo) < 0) {
    perror(filename);
    return 1;
  }

  /* keep atime unchanged */
  new_times[0] = foo.st_atim;

  /* set mtime to current time */
  clock_gettime(CLOCK_REALTIME, &new_times[1]);

  if (utimensat(AT_FDCWD, filename, new_times, 0) < 0) {
    perror(filename);
    return 1;
  }

  return 0;
}
