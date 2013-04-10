import tango.stdc.posix.unistd;

void main() {
  unlink("input.txt");
  unlink("/input.txt");
  rmdir("docs");
  rmdir("/docs");
}
