#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
*  return -1 if s has no repeated characters, otherwise the array
*  index where a duplicated character first reappears
*/
int uniquechars(char *s) {
	int i, j, slen;
	slen = strlen(s);
	if (slen < 2) return -1;
	for (i = 0; i < (slen - 1); i++)
	   for (j = i + 1; j < slen; j++)
	   	   if (s[i] == s[j]) return j;
	return -1;
}

void report(char *s) {
	int pos, first;
	pos = uniquechars(s);
	if (pos == -1)
	    printf("\"%s\" (length = %d) has no duplicate characters\n", s, strlen(s));
	else {
		printf("\"%s\" (length = %d) has duplicate characters:\n", s, strlen(s));
		/* find first instance of duplicated ch in s */
		first = (int) (strchr(s, s[pos]) - s);
		printf("    '%c' (= %2Xh) appears at positions %d and %d\n",
		    s[pos], s[pos], first+1, pos+1);
	}
}

int main(void) {
	report("");
	report(".");
	report("abcABC");
	report("XYZ ZYX");
	report("1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ");
	return EXIT_SUCCESS;
}
