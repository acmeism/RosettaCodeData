/*

https://rosettacode.org/wiki/Count_how_many_vowels_and_consonants_occur_in_a_string

*/

#include <stdio.h>

char vowels[] = {'a','e','i','o','u','\n'};

int len(char * str) {
	int i = 0;
	while (str[i] != '\n') i++;
	return i;
}

int  isvowel(char c){
	int b = 0;
	int v = len(vowels);
	for(int i = 0; i < v;i++) {
		if(c == vowels[i]) {
			b = 1;
			break;
		}
	}
	return b;
}

int isletter(char c){
	return ((c >= 'a') && (c <= 'z') || (c >= 'A') && (c <= 'Z'));
}

int isconsonant(char c){
	return isletter(c) && !isvowel(c);
}

int cVowels(char * str) {
	int i = 0;
	int count = 0;
	while (str[i] != '\n') {
		if (isvowel(str[i])) {
			count++;;
		}
		i++;
	}
	return count;
}

int cConsonants(char * str ) {
	int i = 0;
	int count = 0;
	while (str[i] != '\n') {
		if (isconsonant(str[i])) {
			count++;
		}
		i++;
	}
	return count;
}

int main() {

	char buff[] = "This is 1 string\n";
	printf("%4d, %4d, %4d, %s\n", cVowels(buff), cConsonants(buff), len(buff), buff);

	char buff2[] = "This is a second string\n";
	printf("%4d, %4d, %4d, %s\n", cVowels(buff2), cConsonants(buff2), len(buff2),  buff2);


	printf("a: %d\n", isvowel('a'));
	printf("b: %d\n", isvowel('b'));
	printf("Z: %d\n", isconsonant('Z'));
	printf("1: %d\n", isletter('1'));
}


