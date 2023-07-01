#include <stdio.h>
#include <string.h>

void wrap_text(char *line_start, int width) {
  char *last_space = 0;
  char *p;

  for (p = line_start; *p; p++) {
    if (*p == '\n') {
      line_start = p + 1;
    }

    if (*p == ' ') {
      last_space = p;
    }

    if (p - line_start > width && last_space) {
      *last_space = '\n';
      line_start = last_space + 1;
      last_space = 0;
    }
  }
}

char const text[] =
    "In olden times when wishing still helped one, there lived a king whose "
    "daughters were all beautiful, but the youngest was so beautiful that the "
    "sun itself, which has seen so much, was astonished whenever it shone in "
    "her face. Close by the king's castle lay a great dark forest, and under "
    "an old lime-tree in the forest was a well, and when the day was very "
    "warm, the king's child went out into the forest and sat down by the side "
    "of the cool fountain, and when she was bored she took a golden ball, and "
    "threw it up on high and caught it, and this ball was her favorite "
    "plaything.";

int main(void) {
  char buf[sizeof(text)];

  puts("--- 80 ---");
  memcpy(buf, text, sizeof(text));
  wrap_text(buf, 80);
  puts(buf);

  puts("\n--- 72 ---");
  memcpy(buf, text, sizeof(text));
  wrap_text(buf, 72);
  puts(buf);
}
