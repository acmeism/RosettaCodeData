#include <sys/stat.h>
#include <sys/time.h>
#include <err.h>

const char *filename = "input.txt";

int main() {
  struct stat foo;
  struct timeval new_times[2];

  if (stat(filename, &foo) < 0)
    err(1, "%s", filename);

  /* keep atime unchanged */
  TIMESPEC_TO_TIMEVAL(&new_times[0], &foo.st_atim);

  /* set mtime to current time */
  gettimeofday(&new_times[1], NULL);

  if (utimes(filename, new_times) < 0)
    err(1, "%s", filename);

  return 0;
}
