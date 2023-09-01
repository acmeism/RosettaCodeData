#include <stdio.h>
#include <string.h>

char init[] = "        tH....tH                                            "
              "       .        ......                                      "
              "        ........      .                                     "
              "  ..                 ....           ..       ..       ..    "
              ".. ...               .  ..tH....tH... .tH..... ....tH.. .tH."
              "  ..                 ....           ..       ..       ..    "
              "        tH......      .                                     "
              "       .        ....tH                                      "
              "        ...Ht...                                            ";
int width = 60;
int height = 9;

void wireworld(unsigned int, unsigned int, char *);

int main() {
  char tmp[width + 1] = {};
  do {
    for (int i = 0; i < height; i++) {
      strncpy(tmp, init + i * width, width);
      puts(tmp);
    }
    wireworld(width, height, init);
  } while (getchar());

  return 0;
}
