// $ gcc -o parabrutfor parabrutfor.c -fopenmp -lssl -lcrypto
// $ export OMP_NUM_THREADS=4
// $ ./parabrutfor

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include <openssl/sha.h>

typedef unsigned char byte;

int matches(byte *a, byte* b) {
	for (int i = 0; i < 32; i++)
		if (a[i] != b[i])
			return 0;
	return 1;
}


byte* StringHashToByteArray(const char* s) {
	byte* hash = (byte*) malloc(32);
	char two[3];
	two[2] = 0;
	for (int i = 0; i < 32; i++) {
		two[0] = s[i * 2];
		two[1] = s[i * 2 + 1];
		hash[i] = (byte)strtol(two, 0, 16);
	}
	return hash;
}

void printResult(byte* password, byte* hash) {
	char sPass[6];
	memcpy(sPass, password, 5);
	sPass[5] = 0;
	printf("%s => ", sPass);
	for (int i = 0; i < SHA256_DIGEST_LENGTH; i++)
		printf("%02x", hash[i]);
	printf("\n");
}

int main(int argc, char **argv)
{

#pragma omp parallel
	{

#pragma omp for
		for (int a = 0; a < 26; a++)
		{
			byte password[5] = { 97 + a };
			byte* one =   StringHashToByteArray("1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad");
			byte* two =   StringHashToByteArray("3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b");
			byte* three = StringHashToByteArray("74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f");
			for (password[1] = 97; password[1] < 123; password[1]++)
				for (password[2] = 97; password[2] < 123; password[2]++)
					for (password[3] = 97; password[3] < 123; password[3]++)
						for (password[4] = 97; password[4] < 123; password[4]++) {
							byte *hash = SHA256(password, 5, 0);
							if (matches(one, hash) || matches(two, hash) || matches(three, hash))
								printResult(password, hash);
						}
			free(one);
			free(two);
			free(three);
		}
	}

	return 0;
}
