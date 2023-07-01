/*
  compilation and test in bash
  $ a=./c && make $a && $a ball bell ball ball YUP YEP     ball BELL ball BALL YUP yep
  cc -Wall -c -o c.o c.c
  	eq , ne , gt , lt , ge , le
  ball 0 1 0 1 0 1 bell
  ball 0 1 0 1 0 1 bell ignoring case
  ball 1 0 0 0 1 1 ball
  ball 1 0 0 0 1 1 ball ignoring case
  YUP 0 1 1 0 1 0 YEP
  YUP 0 1 1 0 1 0 YEP ignoring case
  ball 0 1 1 0 1 0 BELL
  ball 0 1 0 1 0 1 BELL ignoring case
  ball 0 1 1 0 1 0 BALL
  ball 1 0 0 0 1 1 BALL ignoring case
  YUP 0 1 0 1 0 1 yep
  YUP 0 1 1 0 1 0 yep ignoring case
*/

#include<string.h>

#define STREQ(A,B) (0==strcmp((A),(B)))
#define STRNE(A,B) (!STREQ(A,B))
#define STRLT(A,B) (strcmp((A),(B))<0)
#define STRLE(A,B) (strcmp((A),(B))<=0)
#define STRGT(A,B) STRLT(B,A)
#define STRGE(A,B) STRLE(B,A)

#define STRCEQ(A,B) (0==strcasecmp((A),(B)))
#define STRCNE(A,B) (!STRCEQ(A,B))
#define STRCLT(A,B) (strcasecmp((A),(B))<0)
#define STRCLE(A,B) (strcasecmp((A),(B))<=0)
#define STRCGT(A,B) STRCLT(B,A)
#define STRCGE(A,B) STRCLE(B,A)

#include<stdio.h>

void compare(const char*a, const char*b) {
  printf("%s%2d%2d%2d%2d%2d%2d %s\n",
	 a,
	 STREQ(a,b), STRNE(a,b), STRGT(a,b), STRLT(a,b), STRGE(a,b), STRLE(a,b),
	 b
	 );
}
void comparecase(const char*a, const char*b) {
  printf("%s%2d%2d%2d%2d%2d%2d %s ignoring case\n",
	 a,
	 STRCEQ(a,b), STRCNE(a,b), STRCGT(a,b), STRCLT(a,b), STRCGE(a,b), STRCLE(a,b),
	 b
	 );
}
int main(int ac, char*av[]) {
  char*a,*b;
  puts("\teq , ne , gt , lt , ge , le");
  while (0 < (ac -= 2)) {
    a = *++av, b = *++av;
    compare(a, b);
    comparecase(a, b);
  }
  return 0;
}
