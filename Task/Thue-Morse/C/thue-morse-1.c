#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){
	char sequence[256+1] = "0";
	char inverse[256+1] = "1";
	char buffer[256+1];
	int i;
	
	for(i = 0; i < 8; i++){
		strcpy(buffer, sequence);
		strcat(sequence, inverse);
		strcat(inverse, buffer);
	}
	
	puts(sequence);
	return 0;
}
