#include <stdio.h>

main() {
  int i = 1;
  while(i <= 100) {
    if(i % 15 == 0)
      puts("FizzBuzz");
    else if(i % 3 == 0)
      puts("Fizz");
    else if(i % 5 == 0)
      puts("Buzz");
    else
      printf("%d\n", i);
    i++;
  }
}
