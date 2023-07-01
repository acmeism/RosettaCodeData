#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void print_headings()
{
	printf("%2s", "N");
	printf(" %10s", "Length");
	printf(" %-20s", "Entropy");
	printf(" %-40s", "Word");
	printf("\n");
}

double calculate_entropy(int ones, int zeros)
{
	double result = 0;
	
	int total = ones + zeros;
	result -= (double) ones / total * log2((double) ones / total);
	result -= (double) zeros / total * log2((double) zeros / total);
	
	if (result != result) { // NAN
		result = 0;
	}
	
	return result;
}

void print_entropy(char *word)
{
	int ones = 0;
	int zeros = 0;
	
	int i;
	for (i = 0; word[i]; i++) {
		char c = word[i];
		
		switch (c) {
			case '0':
				zeros++;
				break;
			case '1':
				ones++;
				break;
		}
	}
	
	double entropy = calculate_entropy(ones, zeros);
	printf(" %-20.18f", entropy);
}

void print_word(int n, char *word)
{
	printf("%2d", n);
	
	printf(" %10ld", strlen(word));
	
	print_entropy(word);
	
	if (n < 10) {
		printf(" %-40s", word);
	} else {
		printf(" %-40s", "...");
	}
	
	printf("\n");
}

int main(int argc, char *argv[])
{
	print_headings();
	
	char *last_word = malloc(2);
	strcpy(last_word, "1");
	
	char *current_word = malloc(2);
	strcpy(current_word, "0");
	
	print_word(1, last_word);
	int i;
	for (i = 2; i <= 37; i++) {
		print_word(i, current_word);
		
		char *next_word = malloc(strlen(current_word) + strlen(last_word) + 1);
		strcpy(next_word, current_word);
		strcat(next_word, last_word);
		
		free(last_word);
		last_word = current_word;
		current_word = next_word;
	}
	
	free(last_word);
	free(current_word);
	return 0;
}
