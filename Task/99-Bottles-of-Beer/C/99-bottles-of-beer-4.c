#include <stdlib.h>
#include <stdio.h>

#define BOTTLE(nstr) nstr " bottles of beer"

#define WALL(nstr) BOTTLE(nstr) " on the wall"

#define PART1(nstr) WALL(nstr) "\n" BOTTLE(nstr) \
                    "\nTake one down, pass it around\n"

#define PART2(nstr) WALL(nstr) "\n\n"

#define MIDDLE(nstr) PART2(nstr) PART1(nstr)

#define SONG PART1("100") CD2 PART2("0")

#define CD2 CD3("9") CD3("8") CD3("7") CD3("6") CD3("5") \
        CD3("4") CD3("3") CD3("2") CD3("1") CD4("")

#define CD3(pre) CD4(pre) MIDDLE(pre "0")

#define CD4(pre) MIDDLE(pre "9") MIDDLE(pre "8") MIDDLE(pre "7") \
 MIDDLE(pre "6") MIDDLE(pre "5") MIDDLE(pre "4") MIDDLE(pre "3") \
 MIDDLE(pre "2") MIDDLE(pre "1")

int main(void)
{
  (void) printf(SONG);
  return EXIT_SUCCESS;
}
