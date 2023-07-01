#include <bitset>
#include <stdio.h>

#define SIZE	           80
#define RULE               30
#define RULE_TEST(x)       (RULE & 1 << (7 & (x)))

void evolve(std::bitset<SIZE> &s) {
    int i;
    std::bitset<SIZE> t(0);
    t[SIZE-1] = RULE_TEST( s[0] << 2 | s[SIZE-1] << 1 | s[SIZE-2] );
    t[     0] = RULE_TEST( s[1] << 2 | s[     0] << 1 | s[SIZE-1] );
    for (i = 1; i < SIZE-1; i++)
	t[i] = RULE_TEST( s[i+1] << 2 | s[i] << 1 | s[i-1] );
    for (i = 0; i < SIZE; i++) s[i] = t[i];
}
void show(std::bitset<SIZE> s) {
    int i;
    for (i = SIZE; i--; ) printf("%c", s[i] ? '#' : ' ');
    printf("|\n");
}
unsigned char byte(std::bitset<SIZE> &s) {
    unsigned char b = 0;
    int i;
    for (i=8; i--; ) {
	b |= s[0] << i;
	evolve(s);
    }
    return b;
}

int main() {
    int i;
    std::bitset<SIZE> state(1);
    for (i=10; i--; )
	printf("%u%c", byte(state), i ? ' ' : '\n');
    return 0;
}
