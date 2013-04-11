#include<stdio.h>

typedef (void *callbackfunc)(const char *);

void doprint(const char *s) {
	printf("%s.", s);
}

void tokenize(char *s, char delim, callbackfunc *cb) {
	char *olds = s;
	char olddelim = delim;
	while(olddelim && *s) {
		while(*s && (delim != *s)) s++;
		*s ^= olddelim = *s; // olddelim = *s; *s = 0;
		cb(olds);
		*s++ ^= olddelim; // *s = olddelim; s++;
		olds = s;
	}
}

int main(void)
{
        char array[] = "Hello,How,Are,You,Today";
	tokenize(array, ',', doprint);
	return 0;
}
