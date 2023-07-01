#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>

uint64_t egyptian_division(uint64_t dividend, uint64_t divisor, uint64_t *remainder) {
	// remainder is an out parameter, pass NULL if you do not need the remainder
	
	static uint64_t powers[64];
	static uint64_t doublings[64];

	int i;
	
	for(i = 0; i < 64; i++) {
		powers[i] = 1 << i;
		doublings[i] = divisor << i;
		if(doublings[i] > dividend)
			break;
	}
	
	uint64_t answer = 0;
	uint64_t accumulator = 0;

	for(i = i - 1; i >= 0; i--) {
		// If the current value of the accumulator added to the
		// doublings cell would be less than or equal to the
		// dividend then add it to the accumulator
		if(accumulator + doublings[i] <= dividend) {
			accumulator += doublings[i];
			answer += powers[i];
		}
	}
	
	if(remainder)
		*remainder = dividend - accumulator;
	return answer;
}

void go(uint64_t a, uint64_t b) {
	uint64_t x, y;
	x = egyptian_division(a, b, &y);
	printf("%llu / %llu = %llu remainder %llu\n", a, b, x, y);
	assert(a == b * x + y);
}

int main(void) {
	go(580, 32);
}
