#include<string.h>
#include<stdio.h>
#include<stdlib.h>

int main(void)
{
	char *a[5];
	const char *s="Hello,How,Are,You,Today";
	int n=0, nn;

	char *ds=strdup(s);

	a[n]=strtok(ds, ",");
	while(a[n] && n<4) a[++n]=strtok(NULL, ",");

	for(nn=0; nn<=n; ++nn) printf("%s.", a[nn]);
	putchar('\n');

	free(ds);

	return 0;
}
