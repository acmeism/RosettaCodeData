#include <stdio.h>

void repeat(void (*f)(void), unsigned int n) {
 while (n-->0)
  (*f)(); //or just f()
}

void example() {
 printf("Example\n");
}

int main(int argc, char *argv[]) {
 repeat(example, 4);
 return 0;
}
