#include <unistd.h>

int main() {
  unlink("input.txt");
  unlink("/input.txt");
  rmdir("docs");
  rmdir("/docs");
  return 0;
}
