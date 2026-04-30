#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>

#define EXECUTE(...) \
	execute((uint8_t[]){ __VA_ARGS__ }, sizeof((uint8_t[]){ __VA_ARGS__ }))

#define NOP  0b000'00000
#define LDA  0b001'00000 |
#define STA  0b010'00000 |
#define ADD  0b011'00000 |
#define SUB  0b100'00000 |
#define BRZ  0b101'00000 |
#define JMP  0b110'00000 |
#define STP  0b111'00000

static uint8_t execute(uint8_t program[], size_t sizeof_program) {
	uint8_t mem[32];
	memcpy(mem, program, sizeof_program * sizeof(*program));
	for(uint8_t acc, pc = 0;; pc &= 0x1f) {
		uint8_t oc = mem[pc++];
		uint8_t op = oc >> 5;
		uint8_t oa = oc & 0x1f;
		switch(op) {
		case 0b000:
			continue;
		case 0b001:
			acc = mem[oa];
			continue;
		case 0b010:
			mem[oa] = acc;
			continue;
		case 0b011:
			acc += mem[oa];
			continue;
		case 0b100:
			acc -= mem[oa];
			continue;
		case 0b101:
			if(acc != 0) continue;
		case 0b110:
			pc = oa;
			continue;
		case 0b111:
			return acc;
		}
	}
}

int main(int argc, char **argv) {
	printf("       2+2: %"PRIu8"\n", EXECUTE(
		LDA 3,
		ADD 4,
		STP  ,
		    0,
		    2,
		    2
	));
	printf("       7*8: %"PRIu8"\n", EXECUTE(
		LDA 12,
		ADD 10,
		STA 12,
		LDA 11,
		SUB 13,
		STA 11,
		BRZ  8,
		JMP  0,
		LDA 12,
		STP   ,
		     8,
		     7,
		     0,
		     1
	));
	printf(" fibonacci: %"PRIu8"\n", EXECUTE(
		LDA 14,
		STA 15,
		ADD 13,
		STA 14,
		LDA 15,
		STA 13,
		LDA 16,
		SUB 17,
		BRZ 11,
		STA 16,
		JMP  0,
		LDA 14,
		STP   ,
		     1,
		     1,
		     0,
		     8,
		     1
	));
	printf("linkedlist: %"PRIu8"\n", EXECUTE(
		LDA 13,
		ADD 15,
		STA  5,
		ADD 16,
		STA  7,
		NOP   ,
		STA 14,
		NOP   ,
		BRZ 11,
		STA 15,
		JMP  0,
		LDA 14,
		STP   ,
		LDA  0,
		     0,
		    28,
		     1,
		     0,
		     0,
		     0,
		     6,
		     0,
		     2,
		    26,
		     5,
		    20,
		     3,
		    30,
		     1,
		    22,
		     4,
		    24
	));
	printf("  prisoner: %"PRIu8"\n", EXECUTE(
		NOP   ,
		NOP   ,
		STP   ,
		     0,
		LDA  3,
		SUB 29,
		BRZ 18,
		LDA  3,
		STA 29,
		BRZ 14,
		LDA  1,
		ADD 31,
		STA  1,
		JMP  2,
		LDA  0,
		ADD 31,
		STA  0,
		JMP  2,
		LDA  3,
		STA 29,
		LDA  1,
		ADD 30,
		ADD  3,
		STA  1,
		LDA  0,
		ADD 30,
		ADD  3,
		STA  0,
		JMP  2,
		     0,
		     1,
		     3
	));
	return 0;
}
